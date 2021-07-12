data "aws_secretsmanager_secret" "databricks_account_username" {
  name = "/databricks/account/username"
}

data "aws_secretsmanager_secret_version" "current_databricks_account_username" {
  secret_id = data.aws_secretsmanager_secret.databricks_account_username.id
}

data "aws_secretsmanager_secret" "databricks_account_password" {
  name = "/databricks/account/password"
}

data "aws_secretsmanager_secret_version" "current_databricks_account_password" {
  secret_id = data.aws_secretsmanager_secret.databricks_account_password.id
}

data "aws_secretsmanager_secret" "databricks_account_id" {
  name = "/databricks/account/id"
}

data "aws_secretsmanager_secret_version" "current_databricks_account_id" {
  secret_id = data.aws_secretsmanager_secret.databricks_account_id.id
}