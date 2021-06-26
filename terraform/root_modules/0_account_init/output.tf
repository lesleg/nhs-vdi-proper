output "terraform_state_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket for Terraform state"
}

output "terraform_state_lock_table_name" {
  value       = aws_dynamodb_table.terraform_state_lock.name
  description = "The name of the DynamoDB table for Terraform state locking"
}
