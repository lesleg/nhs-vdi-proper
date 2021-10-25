environment      = "dev"
region           = "eu-west-2"
s3_bucket_prefix = "nhsd-data-refinery-access-dev"

identity_account_id = "973361696543"
ad_vpc_id           = "vpc-0499b4cbcc698a933"
ad_vpc_cidr_block   = "10.1.0.0/16"

airflow_ui_endpoint_service_name           = "com.amazonaws.vpce.eu-west-2.vpce-svc-06eb77db8d23566bf"
airflow_rest_service_endpoint_service_name = "com.amazonaws.vpce.eu-west-2.vpce-svc-0767e2c8869eb25a9"
airflow_fake_mesh_endpoint_service_name    = "com.amazonaws.vpce.eu-west-2.vpce-svc-0593c5fbd0c414cd1"
gitlab_endpoint_service_name               = "com.amazonaws.vpce.eu-west-2.vpce-svc-049d94ea8a4906f3d"
databricks_endpoint_service_name           = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"

outbound_internet_access_enabled = true
