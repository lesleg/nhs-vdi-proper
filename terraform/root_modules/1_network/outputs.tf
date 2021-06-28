output "vpc_id" {
  value = aws_vpc.default.id
}

output "private_subnet_id_a" {
  value = aws_subnet.private_a.id
}

output "private_subnet_id_b" {
  value = aws_subnet.private_b.id
}

output "private_subnet_id_c" {
  value = aws_subnet.private_c.id
}