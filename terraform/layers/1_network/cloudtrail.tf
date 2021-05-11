resource "aws_cloudtrail" "cloudtrail" {
  name                          = "vdi-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn

  event_selector {
    include_management_events = true
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "vdi-cloudtrail"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2021-04-20",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::vdi-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::vdi-cloudtrail/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "cloudtrail_role" {
  name                  = "VDICloudTrail"
  path                  = "/"
  force_detach_policies = true

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "cloudtrail_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:log-group:*:log-stream:*"]
  }
}

resource "aws_iam_role_policy_attachment" "cloudtrail_logging_policy_attachment" {
  policy_arn = aws_iam_policy.cloudtrail_logging_policy.arn
  role       = aws_iam_role.cloudtrail_role.name
}

resource "aws_iam_policy" "cloudtrail_logging_policy" {
  name   = "VDICloudTrail"
  policy = data.aws_iam_policy_document.cloudtrail_logging_policy.json
}

resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "/vdi/cloudtrail"
}
