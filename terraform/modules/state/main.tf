# Terraform state file setup.
# Create an S3 bucket to store terraform state.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.prefix}-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

# Terraform lock table
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.prefix}-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock Table"
  }
}
