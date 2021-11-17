bucket = "msk-dev-terraform-state"
key = "dev/network/terraform.tfstate"
session_name = "terraform"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "eu-west-1"
encrypt = true