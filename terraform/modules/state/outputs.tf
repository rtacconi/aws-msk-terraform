output "state_bucket" {
  value = aws_s3_bucket.terraform_state.arn
}

output "state_lock" {
  value = aws_dynamodb_table.terraform_state_lock.arn
}
