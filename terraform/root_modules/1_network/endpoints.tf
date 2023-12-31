# AWS Resources with Gateway endpoints
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.dynamodb"
  policy       = data.aws_iam_policy_document.dynamodb.json

  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_b.id,
    aws_route_table.private_c.id,
  ]

  tags = {
    Name = "dynamodb-gateway-endpoint"
  }
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.s3"
  policy       = data.aws_iam_policy_document.s3.json

  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_b.id,
    aws_route_table.private_c.id,
  ]

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

# AWS Resources with Interface endpoints
resource "aws_vpc_endpoint" "rds" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.${var.region}.rds"
  security_group_ids = [aws_security_group.rds_endpoint_sg.id]
  policy             = data.aws_iam_policy_document.rds.json

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "rds-interface-endpoint"
  }
}

data "aws_iam_policy_document" "rds" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_security_group" "rds_endpoint_sg" {
  name        = "rds-interface-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to RDS"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "rds-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.${var.region}.sqs"
  security_group_ids = [aws_security_group.sqs_endpoint_sg.id]
  policy             = data.aws_iam_policy_document.sqs.json

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "sqs-interface-endpoint"
  }
}

data "aws_iam_policy_document" "sqs" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_security_group" "sqs_endpoint_sg" {
  name        = "sqs-interface-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to SQS"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "sqs-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.${var.region}.sts"
  security_group_ids = [aws_security_group.sts_endpoint_sg.id]
  policy             = data.aws_iam_policy_document.sts.json

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "sts-interface-endpoint"
  }
}

data "aws_iam_policy_document" "sts" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_security_group" "sts_endpoint_sg" {
  name        = "sts-interface-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to STS"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "sts-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

# Application-specific Interface endpoints
resource "aws_vpc_endpoint" "airflow_rest_service" {
  count = var.environment == "test" ? 0 : 1

  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.airflow_rest_service_endpoint_service_name
  security_group_ids = [aws_security_group.airflow_rest_service_endpoint_sg.id]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "airflow-rest-service-interface-endpoint"
  }
}

resource "aws_security_group" "airflow_rest_service_endpoint_sg" {
  name        = "airflow-rest-service-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Airflow Rest-Service"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "airflow-rest-service-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "airflow_ui" {
  count = var.environment == "test" ? 0 : 1

  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.airflow_ui_endpoint_service_name
  security_group_ids = [aws_security_group.airflow_ui_endpoint_sg.id]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "airflow-ui-interface-endpoint"
  }
}

resource "aws_security_group" "airflow_ui_endpoint_sg" {
  name        = "airflow-ui-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Airflow UI"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "airflow-ui-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "airflow_fake_mesh" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.airflow_fake_mesh_endpoint_service_name
  security_group_ids = [aws_security_group.airflow_fake_mesh_endpoint_sg.id]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "airflow-fake-mesh-interface-endpoint"
  }
}

resource "aws_security_group" "airflow_fake_mesh_endpoint_sg" {
  name        = "airflow-fake-mesh-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Airflow Fake-Mesh"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "airflow-fake-mesh-endpoint-${terraform.workspace}"
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 8829
    to_port     = 8829
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}

resource "aws_vpc_endpoint" "gitlab" {
  vpc_id             = aws_vpc.default.id
  vpc_endpoint_type  = "Interface"
  service_name       = var.gitlab_endpoint_service_name
  security_group_ids = [aws_security_group.gitlab_endpoint_sg.id]

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "gitlab-interface-endpoint"
  }
}

resource "aws_security_group" "gitlab_endpoint_sg" {
  name        = "gitlab-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Gitlab"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "gitlab-endpoint-${terraform.workspace}"
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

  # Ignore private DNS flag as this is enabled after creation by the null_resource script below
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