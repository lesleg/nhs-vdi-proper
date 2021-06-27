data "terraform_remote_state" "network" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    key    = "vdi-network.tfstate"
    region = "eu-west-2"
    bucket = "${data.aws_iam_account_alias.this.account_alias}-terraform-state"
  }
}