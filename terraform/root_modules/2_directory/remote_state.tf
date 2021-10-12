data "terraform_remote_state" "network" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    key    = "vdi-network.tfstate"
    region = var.region
    bucket = "${var.s3_bucket_prefix}-terraform-state"
  }
}