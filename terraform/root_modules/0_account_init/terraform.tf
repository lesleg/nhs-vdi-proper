terraform {
  required_version = "1.0.0"

  backend "s3" {
    key     = "account-init.tfstate"
    encrypt = true
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
      root_module = "0_account_init"
    }
  }
}