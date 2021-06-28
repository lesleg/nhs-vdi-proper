resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vdi-${terraform.workspace}"
  }
}

resource "aws_vpc_peering_connection_accepter" "ad_to_vdi" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.ad_to_vdi.id
  auto_accept               = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "ad-to-vdi-peering"
  }
}

data "aws_vpc_peering_connection" "ad_to_vdi" {
  owner_id = var.identity_account_id
  vpc_id   = var.ad_vpc_id

  # A bit of nastiness to exclude old peering connections
  # that have since been deleted. Deleted connections still
  # appear in the Access account for a while because the Identity
  # account owns the connection; this breaks the data source filtering
  filter {
    name = "status-code"
    values = [
      "pending-acceptance",
      "active"
    ]
  }
}
