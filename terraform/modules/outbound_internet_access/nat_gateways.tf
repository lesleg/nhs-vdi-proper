resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = var.public_subnet_id_a

  tags = {
    Name = "dae-nat-a"
  }
}

resource "aws_eip" "nat_eip_a" {
  vpc = true

  tags = {
    Name = "dae-nat-eip-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = var.public_subnet_id_b

  tags = {
    Name = "dae-nat-b"
  }
}

resource "aws_eip" "nat_eip_b" {
  vpc = true

  tags = {
    Name = "dae-nat-eip-b"
  }
}


resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.nat_eip_c.id
  subnet_id     = var.public_subnet_id_c

  tags = {
    Name = "dae-nat-c"
  }
}

resource "aws_eip" "nat_eip_c" {
  vpc = true

  tags = {
    Name = "dae-nat-eip-c"
  }
}
