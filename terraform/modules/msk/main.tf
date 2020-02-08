resource "aws_kms_key" "kms" {
  description = "kafka"
}

resource "aws_msk_cluster" "main" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    ebs_volume_size = "1000"
    client_subnets  = var.subnets
    security_groups = var.security_group_ids
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  tags = {
    foo = "bar"
  }
}
