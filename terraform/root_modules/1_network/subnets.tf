resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "vdi-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "vdi-private-b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "vdi-private-c"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "vdi-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "vdi-public-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.region}c"

  tags = {
    Name = "vdi-public-c"
  }
}