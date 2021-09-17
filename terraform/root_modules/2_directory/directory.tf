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
    default_ou = "OU=Workspaces,OU=dare,DC=dare,DC=${var.environment},DC=local"
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

resource "aws_kms_key" "workspace_encryption" {
  description = "Encryption key for workspace volumes"
}

resource "aws_kms_alias" "workspace_encryption" {
  name          = "alias/workspace_encryption"
  target_key_id = aws_kms_key.workspace_encryption.id
}
