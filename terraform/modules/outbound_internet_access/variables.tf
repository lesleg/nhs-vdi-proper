variable "vpc_id" {
  type        = string
  description = "The ID of the VPC which needs NAT internet access"
}

variable "public_subnet_id_a" {
  type        = string
  description = "The ID of the public subnet in availability zone A"
}

variable "public_subnet_id_b" {
  type        = string
  description = "The ID of the public subnet in availability zone B"
}

variable "public_subnet_id_c" {
  type        = string
  description = "The ID of the public subnet in availability zone C"
}

variable "private_route_table_id_a" {
  type        = string
  description = "The ID of the route table for private subnet A"
}

variable "private_route_table_id_b" {
  type        = string
  description = "The ID of the route table for private subnet B"
}

variable "private_route_table_id_c" {
  type        = string
  description = "The ID of the route table for private subnet C"
}