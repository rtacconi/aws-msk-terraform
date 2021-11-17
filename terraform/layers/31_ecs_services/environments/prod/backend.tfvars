bucket = "msk-prod-terraform-state"

key = "prod/terraform.tfstate"

session_name = "terraform"

dynamodb_table = "testmsk-terraform-state-lock"

region = "eu-west-1"

encrypt = true
