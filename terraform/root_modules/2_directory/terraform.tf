terraform {
  backend "s3" {
    key     = "vdi-directory.tfstate"
    encrypt = true
  }

  required_version = "= 1.0.0"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project     = local.project
      env         = var.environment
      workspace   = terraform.workspace
      source      = "terraform"
      root_module = "2_directory"
    }
  }
}
