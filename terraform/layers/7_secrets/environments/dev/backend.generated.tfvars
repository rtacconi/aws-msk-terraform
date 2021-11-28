bucket = "msk-dev-terraform-state"
key = "dev/secrets/terraform.tfstate"
session_name = "secrets"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "eu-west-1"
encrypt = true