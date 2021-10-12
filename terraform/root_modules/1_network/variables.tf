variable "environment" {}
variable "region" {}

variable "s3_bucket_prefix" {}
variable "identity_account_id" {}
variable "ad_vpc_id" {}
variable "ad_vpc_cidr_block" {}
variable "airflow_ui_endpoint_service_name" {}
variable "airflow_rest_service_endpoint_service_name" {}
variable "airflow_fake_mesh_endpoint_service_name" {}
variable "gitlab_endpoint_service_name" {}
variable "databricks_endpoint_service_name" {}

variable "outbound_internet_access_enabled" {
  type    = bool
  default = false
}

variable "cloudtrail_role_name" {
  type    = string
  default = "VDICloudTrail"
}

variable "cloudtrail_policy_name" {
  type    = string
  default = "VDICloudTrail"
}

variable "flow_logs_role_name" {
  type    = string
  default = "VPCFlowLogs"
}