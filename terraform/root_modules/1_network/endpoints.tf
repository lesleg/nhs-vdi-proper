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

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "Databricks endpoint"
  }
}

resource "aws_security_group" "databricks_endpoint_sg" {
  name        = "databricks-endpoint-${terraform.workspace}"
  description = "Security Group for VPC Endpoint to Databrick"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.default.cidr_block]
  }
}