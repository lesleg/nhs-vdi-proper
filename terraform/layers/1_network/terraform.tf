terraform {
  backend "s3" {
    key            = "vdi-network.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}