variable environment {
  type        = string
  description = "The name of the environment"
}

variable project {
  type        = string
  description = "The name of the project"
}

variable cidr {
  type = string
  description = "The VPC cidr"
}

variable private_subnets {
  type = list
  description = "The list of the private subnets cidrs"
}

variable public_subnets {
  type = list
  description = "The list of the public subnets cidrs"
}
