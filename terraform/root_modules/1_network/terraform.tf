terraform {
  backend "s3" {
    key     = "vdi-network.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }

  required_version = "= 1.0.0"
}

provider "aws" {
  region = "eu-west-2"
}
