resource "aws_route53_zone" "private_zone_vdi" {
  name    = "vdi.${var.environment}.local"
  comment = "Private Hosted Zone for Data Refinery"

  vpc {
    vpc_id = aws_vpc.default.id
  }

  # Ignore VPC associations to prevent detachment of AD VPC from this hosted zone
  lifecycle {
    ignore_changes = [
      vpc
    ]
  }
}

resource "aws_route53_vpc_association_authorization" "ad_vpc_authorization_vdi" {
  vpc_id  = var.ad_vpc_id
  zone_id = aws_route53_zone.private_zone_vdi.id
}

resource "aws_route53_record" "airflow" {
  count = var.environment == "test" ? 0 : 1

  zone_id = aws_route53_zone.private_zone_vdi.id
  name    = "airflow"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.airflow_ui[0].dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.airflow_ui[0].dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "rest_service" {
  count = var.environment == "test" ? 0 : 1

  zone_id = aws_route53_zone.private_zone_vdi.id
  name    = "rest-service"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.airflow_rest_service[0].dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.airflow_rest_service[0].dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gitlab" {
  zone_id = aws_route53_zone.private_zone_vdi.id
  name    = "gitlab"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.gitlab.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.gitlab.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "private_zone_airflow" {
  name    = "dps-airflow.local"
  comment = "Private hosted zone matching that in orchestration account - used so that fake-mesh client/server certificates are valid"

  vpc {
    vpc_id = aws_vpc.default.id
  }

  # Ignore VPC associations to prevent detachment of AD VPC from this hosted zone
  lifecycle {
    ignore_changes = [
      vpc
    ]
  }
}

resource "aws_route53_vpc_association_authorization" "ad_vpc_authorization_airflow" {
  vpc_id  = var.ad_vpc_id
  zone_id = aws_route53_zone.private_zone_airflow.id
}

resource "aws_route53_record" "fake-mesh-vdev-default" {
  zone_id = aws_route53_zone.private_zone_airflow.id
  name    = "fake-mesh-vdev-default"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.airflow_fake_mesh.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.airflow_fake_mesh.dns_entry[0].hosted_zone_id
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