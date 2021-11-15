locals {
  prefix = "testmsk-dev"
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "msk-dev-terraform-state"
    key    = "${var.environment}/terraform.tfstate"
    region = var.aws_region
  }
}

resource aws_security_group sg {
  name = "sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc.vpc_id
}

module "kafka" {
  source             = "../../modules/msk"
  cluster_name       = "${local.prefix}-kafka"
  subnets            = data.terraform_remote_state.network.outputs.vpc.private_subnets
  security_group_ids = [aws_security_group.sg.id]
}
