resource "aws_lb_target_group" "target_group" {
  name     = "${var.name_prefix}"
  port     = var.port
  protocol = "HTTP"

  target_type        = "ip"
  vpc_id             = var.vpc_id

  health_check {
    path = var.health_check_path
    port = var.port
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

resource "aws_lb_listener" "alb_port_listener" {
  count = length(var.path_pattern) > 0 ? 0 : 1
  load_balancer_arn = var.aws_lb_arn
  port              = var.port
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

resource "aws_lb_listener_rule" "path_pattern" {
  count = length(var.path_pattern) > 0 ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

resource "aws_ecs_task_definition" "service" {
  family = "${var.name_prefix}-${var.environment}"
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.iam_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = var.container_definitions

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}

resource "aws_security_group" "lb_to_service" {
  name        = "lb-to-service${var.environment}"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from VPC"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    security_groups  = [var.lb_security_group_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-${var.environment}"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.name_prefix}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.lb_to_service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = var.port
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.environment}"
    },
  )
}
