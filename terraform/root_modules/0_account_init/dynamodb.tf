resource "aws_dynamodb_table" "terraform_state_lock" {
  name     = "${data.aws_iam_account_alias.this.account_alias}-terraform-state-lock"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  write_capacity = 10
  read_capacity  = 10
}
  