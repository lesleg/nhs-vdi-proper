resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_a_cidr_block
  availability_zone = "eu-west-2a"

  tags = {
    Name        = "private-a"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_b_cidr_block
  availability_zone = "eu-west-2b"

  tags = {
    Name        = "private-b"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_c_cidr_block
  availability_zone = "eu-west-2c"

  tags = {
    Name        = "private-c"
    project     = "vdi"
    source      = "terraform"
    environment = var.environment
  }
}