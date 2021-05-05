resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.eu-west-2.s3"

  tags = {
    Name        = "S3 endpoint"
    environment = var.environment
  }
}

resource "aws_vpc_endpoint" "rstudio" {
  vpc_id       = aws_vpc.default.id
  service_name = var.rstudio_endpoint_service_name

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id
  ]

  tags = {
    Name        = "RStudio endpoint"
    environment = var.environment
  }
}