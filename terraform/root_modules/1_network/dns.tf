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

resource "aws_route53_record" "databricks" {
  zone_id = aws_route53_zone.private.id
  name    = "databricks"
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.databricks.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.databricks.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
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
