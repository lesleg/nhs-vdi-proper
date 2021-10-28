variable "environment" {}
variable "ad_domain_controller_ips" {}
variable "region" {}
variable "s3_bucket_prefix" {}

variable "workspace_role_name" {
  type    = string
  default = "workspaces_DefaultRole"
}

variable "hscn_network_cidrs" {
  description = "https://nhsd-confluence.digital.nhs.uk/x/VbTzB"
  type        = list(string)

  default = [
    # Misc NHSD
    "193.84.224.0/23",
    "194.101.68.0/24",
    "194.101.82.0/24",
    "194.101.83.0/24",
    "194.176.105.0/24",
    "194.189.27.0/24",
    "195.104.76.0/24",
    "195.104.77.0/24",
    "195.143.82.0/24",
    "212.222.181.0/24",
    # HSCN
    "62.172.169.0/25",
    "62.6.52.0/24",
    # NHSD ForcePoint Cloud Proxy
    "85.115.52.0/24",
    "85.115.53.0/24",
    "85.115.54.0/24",
    # AWS VPN
    "3.10.167.180/32",
    "3.10.37.54/32",
    "3.11.106.35/32",
    # CNSP
    "208.127.192.0/21",
    # Leeds Hub
    "194.101.80.0/24",
    "155.231.226.0/24"
  ]
}
