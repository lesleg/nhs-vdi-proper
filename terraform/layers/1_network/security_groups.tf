resource aws_security_group rstudio_endpoint_sg {
  vpc_id      = aws_vpc.default.id
  name        = "rstudio-endpoint-sg"
  description = "Security Group for VPC Endpoint to RStudio"

  tags = {
    Name        = "rstudio-endpoint-sg"
    source      = "terraform"
    project     = "vdi"
    environment = var.environment
  }
}