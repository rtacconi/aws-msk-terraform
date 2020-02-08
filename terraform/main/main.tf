locals {
  prefix = "testmsk-dev"
  common_tags = {
    project     = var.project
    environment = var.environment
  }
  private_subnets = ["192.168.0.0/24", "192.168.10.0/24", "192.168.20.0/24"]
  public_subnets  = ["192.168.0.0/24", "192.168.10.0/24", "192.168.20.0/24"]
}

data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.7.0"

  name = "${local.prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs                = data.aws_availability_zones.azs.names
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  tags               = local.common_tags
  enable_nat_gateway = true
}

resource "aws_security_group" "sg" {
  vpc_id = module.vpc.vpc_id
}

module "kafka" {
  source             = "./modules/msk"
  cluster_name       = "${local.prefix}-kafka"
  subnets            = module.vpc.private_subnets
  security_group_ids = [aws_security_group.sg.id]
}
