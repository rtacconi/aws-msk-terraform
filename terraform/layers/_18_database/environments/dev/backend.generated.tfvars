bucket = "msk-dev-terraform-state"
key = "dev/database/terraform.tfstate"
session_name = "database"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "eu-west-1"
encrypt = true