resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vdi-default"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}