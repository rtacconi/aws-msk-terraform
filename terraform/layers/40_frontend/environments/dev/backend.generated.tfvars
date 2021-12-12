bucket = "msk-dev-us-east-1-terraform-state"
key = "dev/frontend/terraform.tfstate"
session_name = "frontend"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "us-east-1"
encrypt = true
