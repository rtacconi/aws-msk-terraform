locals {
  prefix = "${var.project}-${var.environment}"
  common_tags = {
    project     = var.project
    environment = var.environment
  }
}

resource "aws_secretsmanager_secret" "application" {
  description = "Map of application secrets"
  name        = local.prefix

  tags = local.common_tags
}

variable "example" {
  default = {
    key1 = "value1"
    key2 = "value2"
  }

  type = map(string)
}

resource "aws_secretsmanager_secret_version" "application" {
  secret_id     = aws_secretsmanager_secret.application.id
  secret_string = jsonencode(var.example)
}
