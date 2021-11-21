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

variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the LB is deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnets to deploy the ALB"
  type        = list
}

variable "dns_name" {
  description = "DNS name used by the certificate"
  type        = string
}

variable "zone_id" {
  description = "DNS zone ID"
  type        = string
}

variable "cidr_blocks_ingress" {
  description = "CIDR block for inbound traffic"
  default     = ["0.0.0.0/0"]
}
