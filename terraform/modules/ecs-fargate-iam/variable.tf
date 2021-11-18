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

variable "execution_task_policy" {
  description = "JSON policy to be used by the execution policy (optional)"
  type        = string
  default     = ""
}

variable "task_policy" {
  description = "JSON policy to be used by the task policy for the container permissions (optional)"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "tags" {
  description = "Map of common tags to apply to resources"
  type        = map
}