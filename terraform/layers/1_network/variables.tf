variable environment {}

variable account_id {}

variable cidr_block {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable private_subnet_a_cidr_block {
  default = "10.0.0.0/24"
}

variable private_subnet_b_cidr_block {
  default = "10.0.1.0/24"
}

variable private_subnet_c_cidr_block {
  default = "10.0.2.0/24"
}

variable rstudio_endpoint_service_name {}

variable s3_bucket_prefix {}