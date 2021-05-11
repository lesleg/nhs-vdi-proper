terraform {
  backend "s3" {
    key     = "vdi-network.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }

  required_version = "= 0.15.1"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 3.34.0"
}
