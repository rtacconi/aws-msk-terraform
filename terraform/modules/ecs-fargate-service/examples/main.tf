module "service_nginx" {
  source               = "./modules/ecs_fargate_service"
  environment          = var.environment
  container_name       = "nginx-test-${var.environment}"
  cpu                  = 256
  memory               = 512
  aws_region           = var.aws_region
  aws_account_id       = var.aws_account_id
  name_prefix          = "assets"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  aws_lb_arn           = aws_lb.cci_lp.arn
  ecs_cluster_id       = aws_ecs_cluster.cci_lp_cluster.id
  lb_security_group_id = aws_security_group.lb_internet_traffic.id
  path_pattern         = "/asset-service"
  listener_arn         = aws_lb_listener.alb_cci_lp_asset_service_listener.arn

  container_definitions = jsonencode([
    {
      "name": "nginx-test-${var.environment}",
      "image": "663534223943.dkr.ecr.eu-west-1.amazonaws.com/nginx:latest",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": aws_cloudwatch_log_group.log_group.name,
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp",
          "hostPort": 80
        }
      ]
    }
  ])

  tags   = local.launchpad_tags
}
