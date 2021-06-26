terraform {
  required_version = "1.0.0"

  backend "s3" {
    key     = "account-init.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
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