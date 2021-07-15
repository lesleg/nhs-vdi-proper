module "outbound_internet_access" {
  count = var.outbound_internet_access_enabled ? 1 : 0

  source = "../../modules/outbound_internet_access"

  vpc_id = aws_vpc.default.id

  public_subnet_id_a = aws_subnet.public_a.id
  public_subnet_id_b = aws_subnet.public_b.id
  public_subnet_id_c = aws_subnet.public_c.id

  private_route_table_id_a = aws_route_table.private_a.id
  private_route_table_id_b = aws_route_table.private_b.id
  private_route_table_id_c = aws_route_table.private_c.id

  depends_on = [
    aws_internet_gateway.vdi_igw
  ]
}