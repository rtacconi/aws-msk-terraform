resource "aws_security_group" "lb_internet_traffic" {
  name        = "${var.name_prefix}-inbound"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks_ingress
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

resource "aws_lb" "alb" {
  name               = var.name_prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_internet_traffic.id]

  subnets            = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code = "200"
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

# ECS Cluster
resource "aws_kms_key" "key" {
  description             = "${var.name_prefix} key"
  deletion_window_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "${var.name_prefix}-cluster"

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

resource "aws_ecs_cluster" "cluster" {
  name = var.name_prefix

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = var.name_prefix

  tags = merge(
    var.tags,
    {
      Name = var.name_prefix
    },
  )
}
