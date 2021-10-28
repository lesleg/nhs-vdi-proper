#tfsec:ignore:GEN003 Remove when we no longer hardcode the dev password
resource "aws_directory_service_directory" "connector" {
  name     = "dare.${var.environment}.local"
  password = local.ad_admin_password
  size     = "Small"
  type     = "ADConnector"

  connect_settings {
    customer_dns_ips  = var.ad_domain_controller_ips
    customer_username = "Admin"
    vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
    subnet_ids = [
      data.terraform_remote_state.network.outputs.private_subnet_id_a,
      data.terraform_remote_state.network.outputs.private_subnet_id_b
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
}

#tfsec:ignore:AWS095 An AWS managed key is fine here
resource "aws_secretsmanager_secret" "ad_admin_password" {
  name = "secret/active_directory/ad_admin_password"
}

data "aws_secretsmanager_secret_version" "ad_admin_password" {
  secret_id = aws_secretsmanager_secret.ad_admin_password.id
}

resource "aws_workspaces_directory" "example" {
  directory_id = aws_directory_service_directory.connector.id

  subnet_ids = [
    data.terraform_remote_state.network.outputs.private_subnet_id_a,
    data.terraform_remote_state.network.outputs.private_subnet_id_b
  ]

  workspace_creation_properties {
    default_ou               = "OU=Workspaces,OU=dare,DC=dare,DC=${var.environment},DC=local"
    custom_security_group_id = aws_security_group.workspaces_sg.id
  }

  workspace_access_properties {
    device_type_linux      = "ALLOW"
    device_type_android    = "DENY"
    device_type_chromeos   = "DENY"
    device_type_ios        = "DENY"
    device_type_osx        = "ALLOW"
    device_type_web        = "ALLOW"
    device_type_windows    = "ALLOW"
    device_type_zeroclient = "DENY"
  }
}

#tfsec:ignore:AWS019 Need to look into the implications of rotating keys used to encrypt workspaces
resource "aws_kms_key" "workspace_encryption" {
  description = "Encryption key for workspace volumes"
}

resource "aws_kms_alias" "workspace_encryption" {
  name          = "alias/workspace_encryption"
  target_key_id = aws_kms_key.workspace_encryption.id
}

#tfsec:ignore:AWS009 This is a copy of the default workspaces SG to be customised later. Egress all is intended, but we can remove this if that changes
resource "aws_security_group" "workspaces_sg" {
  name        = "workspaces_sg"
  description = "Security Group for Amazon Workspaces"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "workspaces-sg"
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_workspaces_ip_group" "HSCN" {
  name        = "HSCN"
  description = "HSCN IP access control group"

  rules       = [for range in var.hscn_network_cidrs : {description = range, source = range}]

  }


