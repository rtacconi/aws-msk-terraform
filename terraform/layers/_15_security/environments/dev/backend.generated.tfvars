bucket = "msk-dev-terraform-state"
key = "dev/security/terraform.tfstate"
session_name = "security"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "eu-west-1"
encrypt = true