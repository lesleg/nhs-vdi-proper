resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-private-route-table"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_subnets_to_ad_vpc" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.ad_vpc_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.ad_to_vdi.id
}