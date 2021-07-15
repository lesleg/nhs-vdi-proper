environment      = "dev"
region           = "eu-west-2"
s3_bucket_prefix = "nhsd-data-refinery-access-dev"

identity_account_id = 973361696543
ad_vpc_id           = "vpc-0499b4cbcc698a933"
ad_vpc_cidr_block   = "10.1.0.0/16"

airflow_endpoint_service_name    = "com.amazonaws.vpce.eu-west-2.vpce-svc-0251d7b6a8033201e"
databricks_endpoint_service_name = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"

outbound_internet_access_enabled = true