# Route tables for private subnets
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-private-route-table-a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-private-route-table-b"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-private-route-table-c"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}

# Routing from private subnets to peering connection to Active Directory
resource "aws_route" "private_subnet_a_to_ad_vpc" {
  route_table_id            = aws_route_table.private_a.id
  destination_cidr_block    = var.ad_vpc_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.ad_to_vdi.id
}

resource "aws_route" "private_subnet_b_to_ad_vpc" {
  route_table_id            = aws_route_table.private_b.id
  destination_cidr_block    = var.ad_vpc_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.ad_to_vdi.id
}

resource "aws_route" "private_subnet_c_to_ad_vpc" {
  route_table_id            = aws_route_table.private_c.id
  destination_cidr_block    = var.ad_vpc_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.ad_to_vdi.id
}

# Route tables for public subnets
resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-public-route-table-a"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-public-route-table-b"
  }
}

resource "aws_route_table" "public_c" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-public-route-table-c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_c.id
}


# Routing from public subnets to the internet gateway
resource "aws_route" "public_subnet_a_to_igw" {
  route_table_id         = aws_route_table.public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vdi_igw.id
}

resource "aws_route" "public_subnet_b_to_igw" {
  route_table_id         = aws_route_table.public_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vdi_igw.id
}

resource "aws_route" "public_subnet_c_to_igw" {
  route_table_id         = aws_route_table.public_c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vdi_igw.id
}