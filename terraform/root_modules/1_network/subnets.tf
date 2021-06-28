resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name        = "vdi-private-a"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name        = "vdi-private-b"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name        = "vdi-private-c"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}