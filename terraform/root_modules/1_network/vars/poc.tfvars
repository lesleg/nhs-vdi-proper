environment      = "poc"
region           = "eu-west-1"
s3_bucket_prefix = "nhsd-data-refinery-access-poc"

identity_account_id = "973361696543"
ad_vpc_id           = "vpc-0fd30d8760b4a1fec"
ad_vpc_cidr_block   = "10.1.0.0/16"

airflow_ui_endpoint_service_name           = "unknown"                                                 # airflow-dev in eu-west-2 as no endpoint in eu-west-1 poc
airflow_rest_service_endpoint_service_name = "unknown"                                                 # airflow-dev in eu-west-2 as no endpoint in eu-west-1 poc
gitlab_endpoint_service_name               = "unknown"                                                 # gitlab-dev in eu-west-2 as no endpoint in eu-west-1 poc
databricks_endpoint_service_name           = "com.amazonaws.vpce.eu-west-1.vpce-svc-0da6ebf1461278016" # databricks control plane in eu-west-1 (from their website)

cloudtrail_role_name   = "VDICloudTrail-POC"
cloudtrail_policy_name = "VDICloudTrail-POC"
flow_logs_role_name    = "VPCFlowLogs-POC"