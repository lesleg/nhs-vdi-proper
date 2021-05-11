provider "aws" {
  region  = "eu-west-2"
  version = "~> 3.34.0"
}

terraform {
  required_version = "= 0.13.4"
}