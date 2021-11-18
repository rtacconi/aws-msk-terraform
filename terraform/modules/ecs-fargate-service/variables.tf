variable "aws_region" {
  description = "AWS region to launch servers"
}

variable "aws_account_id" {
  description = "AWS account ID"
}

variable "environment" {
  description = "Current environment"
  default     = "dev"
  type        = string
}

variable "tags" {
  description = "Map of common tags to apply to resources"
  type        = map
}

variable "container_definitions" {
  description = "JSON code to define the task"
  type        = string
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "cpu" {
  description = "CPU units assigned to the definition task"
  default     = 256
  type        = number
}

variable "memory" {
  description = "Memory units assigned to the definition task"
  default     = 512
  type        = number
}

variable "port" {
  description = "Container port"
  type        = string
}

variable "health_check_grace_period_seconds" {
  default     = 300
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers."
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  default     = 50
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
}

variable "deployment_maximum_percent" {
  default     = 200
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment"
  type        = number
}

variable "vpc_id" {
  description = "ID of the VPC to be used to deploy the service"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet to deploy the service"
  type        = list
}

variable "aws_lb_arn" {
  description = "ARN of the ALB used by the aws_lb_listener"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID used to deploy the ECS service"
  type        = string
}

variable "lb_security_group_id" {
  description = "Security group ID of the load balancer to allow inbound traffic"
  type        = string
}

variable "path_pattern" {
  description = "URI path to map the load-balancer to a service"
  type        = string
  default     = ""
}

variable "listener_arn" {
  description = "Listener to attach the routing rule"
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN used by the task"
}

variable "execution_role_arn" {
  description = "Execution role ARN used by the task"
}

variable "health_check_path" {
  description = "Path of the endpoint to be tested"
  default     = "/"
  type        = string
}
