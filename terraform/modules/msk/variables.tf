variable "cluster_name" {
  type        = string
  default     = "main"
  description = "The name of the Kafka cluster"
}

variable "kafka_version" {
  type        = string
  default     = "2.2.1"
  description = "The version of Kafka"
}

variable "subnets" {
  type        = list(string)
  description = "List of private subnets to run EC@ servers for Kafka"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security groups to assign to Kafka cluster"
}
