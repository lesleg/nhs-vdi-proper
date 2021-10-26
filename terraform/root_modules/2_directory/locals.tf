data "aws_iam_account_alias" "this" {}

locals {
  project = "DARE-access"

  # Temporarily hardcode admin password for dev to avoid rebuilding AD Connector. We will rebuild it once we're released beyond dev
  #tfsec:ignore:GEN002 Remove when we no longer hardcode the dev password
  ad_admin_password = var.environment == "dev" ? "Pa55word123" : data.aws_secretsmanager_secret_version.ad_admin_password.secret_string
}