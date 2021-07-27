resource "aws_route53_zone" "private" {
  name    = "vdi.${var.environment}.local"
  comment = "Private Hosted Zone for Data Refinery"

  vpc {
    vpc_id = aws_vpc.default.id
  }
}

resource "aws_route53_vpc_association_authorization" "ad_vpc_authorization" {
  vpc_id  = var.ad_vpc_id
  zone_id = aws_route53_zone.private.id
}

resource "aws_route53_record" "airflow" {
  zone_id = aws_route53_zone.private.id
  name    = "airflow"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.airflow.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.airflow.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_resolver_endpoint" "inbound_resolver" {
  name      = "inbound-resolver"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.inbound_resolver_sg.id
  ]

  ip_address {
    subnet_id = aws_subnet.private_a.id
    ip        = "10.0.0.4"
  }

  ip_address {
    subnet_id = aws_subnet.private_b.id
    ip        = "10.0.1.4"
  }
}

resource "aws_security_group" "inbound_resolver_sg" {
  name        = "inbound-dns-resolver"
  description = "Security Group for inbound Route53 Resolver Endpoint"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name = "inbound-dns-resolver"
  }

  ingress {
    description = "DNS(TCP) from AD VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.ad_vpc_cidr_block]
  }

  ingress {
    description = "DNS(UDP) from AD VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.ad_vpc_cidr_block]
  }
}