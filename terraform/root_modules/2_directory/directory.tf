resource "aws_directory_service_directory" "connector" {
  name     = "dare.${var.environment}.local"
  password = "Pa55word123" #TODO: Update this once Admin password is in Secrets Manager
  size     = "Small"
  type     = "ADConnector"

  connect_settings {
    customer_dns_ips  = [
      "10.1.1.197",
      "10.1.2.237"
    ]
    customer_username = "Admin"
    vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
    subnet_ids        = [
      data.terraform_remote_state.network.outputs.private_subnet_id_a,
      data.terraform_remote_state.network.outputs.private_subnet_id_b
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
}

resource "aws_workspaces_directory" "example" {
  directory_id = aws_directory_service_directory.connector.id
  subnet_ids   = [
    data.terraform_remote_state.network.outputs.private_subnet_id_a,
    data.terraform_remote_state.network.outputs.private_subnet_id_b
  ]

  workspace_access_properties {
    device_type_android    = "DENY"
    device_type_chromeos   = "DENY"
    device_type_ios        = "DENY"
    device_type_osx        = "ALLOW"
    device_type_web        = "ALLOW"
    device_type_windows    = "ALLOW"
    device_type_zeroclient = "DENY"
  }
}