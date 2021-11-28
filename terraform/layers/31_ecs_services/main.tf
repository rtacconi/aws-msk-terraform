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

data "aws_route53_zone" "selected" {
  name = "recursivelabs.cloud."
}

data "aws_caller_identity" "current" {}

module "nginx_service_iam" {
  source               = "../../modules/ecs-fargate-iam"
  aws_region           = local.aws_region
  aws_account_id       = local.aws_account_id
  environment          = var.environment
  name_prefix          = local.prefix

  tags   = local.common_tags
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "demo-service"

  tags = local.common_tags
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
  tags = local.common_tags
}

module "service_nginx" {
  depends_on           = [aws_ecr_repository.nginx]
  source               = "../../modules/ecs-fargate-service"
  environment          = var.environment
  container_name       = "nginx-${var.environment}"
  cpu                  = 256
  memory               = 512
  port                 = 5000
  aws_region           = local.aws_region
  aws_account_id       = local.aws_account_id
  name_prefix          = local.prefix
  vpc_id               = data.terraform_remote_state.network.outputs.vpc.vpc_id
  private_subnet_ids   = data.terraform_remote_state.network.outputs.vpc.private_subnets
  aws_lb_arn           = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster.aws_lb_arn
  ecs_cluster_id       = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster.ecs_cluster_id
  lb_security_group_id = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster.lb_aws_security_group_id
  path_pattern         = "/demo-servic*"
  listener_arn         = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster.aws_lb_listener_arn
  execution_role_arn   = module.nginx_service_iam.execution_role_arn
  iam_role_arn         = module.nginx_service_iam.iam_role_arn
  health_check_path    = "/"
  priority             = 100

  container_definitions = jsonencode([
    {
      "name": "nginx-${var.environment}",
      "image": "${aws_ecr_repository.nginx.repository_url}:0.0.4",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": aws_cloudwatch_log_group.log_group.name,
          "awslogs-region": "${local.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "environment": [
        # {
        #   "name": "APPLICATION_ROOT",
        #   "value": "/"
        # }
      ],
      "portMappings": [
        {
          "containerPort": 5000,
          "protocol": "tcp",
          "hostPort": 5000
        }
      ]
    }
  ])

  tags   = local.common_tags
}
