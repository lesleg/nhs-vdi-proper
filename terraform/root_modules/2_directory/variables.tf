variable "environment" {}
variable "ad_domain_controller_ips" {}
variable "region" {}
variable "s3_bucket_prefix" {}

variable "workspace_role_name" {
  type    = string
  default = "workspaces_DefaultRole"
}