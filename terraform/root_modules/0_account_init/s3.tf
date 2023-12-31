#tfsec:ignore:AWS002 We don't need to have logging enabled here
#tfsec:ignore:AWS098 We may want to add a specific public access block, but there is an account one below
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${data.aws_iam_account_alias.this.account_alias}-terraform-state"

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
}

resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}