environment      = "int"
region           = "eu-west-2"
s3_bucket_prefix = "nhsd-data-refinery-access-int"

identity_account_id = "338157856608"
ad_vpc_id           = "vpc-08cee8fa826b71d3e"
ad_vpc_cidr_block   = "10.1.0.0/16"

airflow_ui_endpoint_service_name           = "com.amazonaws.vpce.eu-west-2.vpce-svc-0f598f048916bb863"
airflow_rest_service_endpoint_service_name = "com.amazonaws.vpce.eu-west-2.vpce-svc-04cc2c4c06ae05af5"
airflow_fake_mesh_endpoint_service_name    = "com.amazonaws.vpce.eu-west-2.vpce-svc-0e5526ac734f3135f"
gitlab_endpoint_service_name               = "com.amazonaws.vpce.eu-west-2.vpce-svc-02396a88c7f64a82b"
databricks_endpoint_service_name           = "com.amazonaws.vpce.eu-west-2.vpce-svc-01148c7cdc1d1326c"
