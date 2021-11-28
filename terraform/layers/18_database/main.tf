locals {
  prefix = "${var.project}-${var.environment}"
  aws_region = "eu-west-1"
  aws_account_id = data.aws_caller_identity.current.account_id
  database_name = "flask"
  common_tags = {
    project     = var.project
    environment = var.environment
  }

}

data "aws_caller_identity" "current" {}

module "aurora_postgresql" {
  source = "../../modules/terraform-aws-rds-serverless"

  name              = "${local.prefix}-postgresql"
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true

  vpc_id                = data.terraform_remote_state.network.outputs.vpc.vpc_id
  subnets               = data.terraform_remote_state.network.outputs.vpc.private_subnets
  create_security_group = true
  allowed_cidr_blocks   = data.terraform_remote_state.network.outputs.vpc.private_subnets_cidr_blocks

  monitoring_interval = 60

  database_name = local.database_name

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "${local.prefix}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql10"
  description = "${local.prefix}-aurora-db-postgres-parameter-group"
  tags        = local.common_tags
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "${local.prefix}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "${local.prefix}-aurora-postgres-cluster-parameter-group"
  tags        = local.common_tags
}

resource "aws_secretsmanager_secret_version" "application" {
  secret_id     = data.terraform_remote_state.secrets.outputs.application.id
  secret_string = jsonencode(
    {
      "database_name"           = local.database_name,
      "database_username"       = module.aurora_postgresql.cluster_master_username,
      "database_password"       = module.aurora_postgresql.cluster_master_password,
      "cluster_port"            = module.aurora_postgresql.cluster_port,
      "cluster_endpoint"        = module.aurora_postgresql.cluster_endpoint
    }
  )
}
