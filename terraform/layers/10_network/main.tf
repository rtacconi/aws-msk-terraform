locals {
  prefix = "${var.project}-${var.environment}"
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = "${local.prefix}-vpc"
  cidr = var.cidr

  azs                = data.aws_availability_zones.azs.names
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  tags               = local.common_tags
  enable_nat_gateway = true
}
