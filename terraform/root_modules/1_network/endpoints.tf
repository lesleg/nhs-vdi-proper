resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.eu-west-2.s3"

  tags = {
    Name = "S3 endpoint"
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
    Name = "Airflow endpoint"
  }
}

resource "aws_security_group" "airflow_endpoint_sg" {
  name        = "airflow-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Airflow"
  vpc_id      = aws_vpc.default.id

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

  # NOTE: Databricks endpoint service does not support AZs b and c in eu-west-2
  subnet_ids = [
    aws_subnet.private_a.id
  ]

  tags = {
    Name = "Databricks endpoint"
  }
}

resource "aws_security_group" "databricks_endpoint_sg" {
  name        = "databricks-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Databricks"
  vpc_id      = aws_vpc.default.id

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