locals {
  prefix = "${var.project}-${var.environment}"
  aws_region = "eu-west-1"
  aws_account_id = data.aws_caller_identity.current.account_id
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_route53_zone" "selected" {
  name = "recursivelabs.cloud."
}

data "aws_caller_identity" "current" {}

module "ecs_cluster_test" {
  source         = "../../modules/ecs-cluster"
  aws_region     = local.aws_region
  aws_account_id = local.aws_account_id
  environment    = var.environment
  name_prefix    = local.prefix

  vpc_id         = data.terraform_remote_state.network.outputs.vpc.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.vpc.public_subnets
  dns_name       = "ecs.recursivelabs.cloud"
  zone_id        = data.aws_route53_zone.selected.zone_id

  tags   = local.common_tags
}
