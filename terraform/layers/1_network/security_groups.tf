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

resource aws_security_group hue_endpoint_sg {
  vpc_id      = aws_vpc.default.id
  name        = "hue-endpoint-sg"
  description = "Security Group for VPC Endpoint to Hue"

  tags = {
    Name        = "hue-endpoint-sg"
    source      = "terraform"
    project     = "vdi"
    environment = var.environment
  }
}