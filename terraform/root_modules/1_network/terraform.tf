terraform {
  required_version = "= 1.0.0"

  backend "s3" {
    key     = "vdi-network.tfstate"
    encrypt = true
  }

  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.5"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project     = local.project
      env         = var.environment
      workspace   = terraform.workspace
      source      = "terraform"
      root_module = "1_network"
    }
  }
}

provider "databricks" {
  host     = "https://accounts.cloud.databricks.com"
  username = data.aws_secretsmanager_secret_version.current_databricks_account_username.secret_string
  password = data.aws_secretsmanager_secret_version.current_databricks_account_password.secret_string
}
