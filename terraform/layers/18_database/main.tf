locals {
  name   = "example-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

module "aurora_postgresql" {
  source = "../../modules/terraform-aws-rds-serverless"

  name              = "${local.name}-postgresql"
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true

  vpc_id                = data.terraform_remote_state.network.outputs.vpc.vpc_id
  subnets               = data.terraform_remote_state.network.outputs.vpc.private_subnets
  create_security_group = true
  allowed_cidr_blocks   = data.terraform_remote_state.network.outputs.vpc.private_subnets_cidr_blocks

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.example_postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example_postgresql.id

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 16
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "example_postgresql" {
  name        = "${local.name}-aurora-db-postgres-parameter-group"
  family      = "aurora-postgresql10"
  description = "${local.name}-aurora-db-postgres-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "example_postgresql" {
  name        = "${local.name}-aurora-postgres-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "${local.name}-aurora-postgres-cluster-parameter-group"
  tags        = local.tags
}
