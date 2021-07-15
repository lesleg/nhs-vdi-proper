# Routing from private subnets to NAT gateways
resource "aws_route" "private_subnet_a_to_nat_a" {
  route_table_id         = var.private_route_table_id_a
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id
}

resource "aws_route" "private_subnet_b_to_nat_b" {
  route_table_id         = var.private_route_table_id_b
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_b.id
}

resource "aws_route" "private_subnet_c_to_nat_c" {
  route_table_id         = var.private_route_table_id_c
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_c.id
}