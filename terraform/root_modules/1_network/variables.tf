variable "environment" {}
variable "region" {}

variable "s3_bucket_prefix" {}
variable "identity_account_id" {}
variable "ad_vpc_id" {}
variable "ad_vpc_cidr_block" {}
variable "airflow_endpoint_service_name" {}
variable "databricks_endpoint_service_name" {}

variable "outbound_internet_access_enabled" {
  type    = bool
  default = false
}