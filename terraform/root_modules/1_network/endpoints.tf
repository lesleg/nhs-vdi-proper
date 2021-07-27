resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.eu-west-2.s3"

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

resource "aws_vpc_endpoint" "airflow" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.airflow_endpoint_service_name
  security_group_ids = [aws_security_group.airflow_endpoint_sg.id]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "airflow-interface-endpoint"
  }
}

resource "aws_security_group" "airflow_endpoint_sg" {
  name        = "airflow-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Airflow"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "airflow-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "databricks" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.databricks_endpoint_service_name
  security_group_ids = [aws_security_group.databricks_endpoint_sg.id]

  tags = {
    Name = "databricks-interface-endpoint"
  }

  # NOTE: Databricks endpoint service does not support AZs b and c in eu-west-2
  subnet_ids = [
    aws_subnet.private_a.id
  ]
  lifecycle {
    ignore_changes = [
      private_dns_enabled
    ]
  }
}

/*
 Can't enable private DNS on the endpoint until it has been registered with Databricks.
 (See the databricks_mws_vpc_endpoint resource in this file)
 The following resource runs a script that waits until the endpoint state is 'available'
 and then turns on the private DNS feature.
*/
resource "null_resource" "enable_databricks_private_dns" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
    set -e
    i=0
    while [ $(aws --profile=access_$ENVIRONMENT ec2 describe-vpc-endpoints --vpc-endpoint-ids $VPC_ENDPOINT_ID | jq -r '.[] | first | .State') != 'available' ]; do
      if [ $i -gt 60 ]; then
        echo "Timed out waiting for $VPC_ENDPOINT_NAME endpoint to become available";
        exit 1
      fi
      echo "Waiting for the $VPC_ENDPOINT_NAME endpoint to become available";
      sleep 10;
      ((i+=1))
    done;
    echo "$VPC_ENDPOINT_NAME is available!";
    aws --profile=access_$ENVIRONMENT ec2 modify-vpc-endpoint --vpc-endpoint-id $VPC_ENDPOINT_ID --private-dns-enabled;
EOF
    environment = {
      VPC_ENDPOINT_ID   = aws_vpc_endpoint.databricks.id
      VPC_ENDPOINT_NAME = aws_vpc_endpoint.databricks.tags["Name"]
      ENVIRONMENT       = var.environment
    }
  }
}

resource "aws_security_group" "databricks_endpoint_sg" {
  name        = "databricks-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Databricks"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "databricks-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "databricks_mws_vpc_endpoint" "databricks" {
  provider            = databricks
  account_id          = data.aws_secretsmanager_secret_version.current_databricks_account_id.secret_string
  aws_vpc_endpoint_id = aws_vpc_endpoint.databricks.id
  vpc_endpoint_name   = "Databricks APIs ${var.environment} ${aws_vpc.default.id}"
  region              = var.region
}