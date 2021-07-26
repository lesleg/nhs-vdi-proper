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

resource "aws_internet_gateway" "vdi_igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "vdi-igw-${terraform.workspace}"
  }
}

resource "aws_flow_log" "vdi_vpc_flow_log" {
  log_destination = "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  vpc_id          = aws_vpc.default.id
  traffic_type    = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "/vdi/vpc_flow_logs"
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "VPCFlowLogs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_logs_access_to_cloudwatch" {
  name = aws_iam_role.vpc_flow_logs.name
  role = aws_iam_role.vpc_flow_logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}