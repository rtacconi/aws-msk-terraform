data "terraform_remote_state" "secrets" {
  backend = "s3"
  config = {
    bucket = "msk-dev-terraform-state"
    key    = "${var.environment}/secrets/terraform.tfstate"
    region = local.aws_region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "msk-dev-terraform-state"
    key    = "${var.environment}/network/terraform.tfstate"
    region = local.aws_region
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = "msk-dev-terraform-state"
    key    = "${var.environment}/ecs-cluster/terraform.tfstate"
    region = local.aws_region
  }
}
