variable "vpc_id" {
  description = "VPC Id"
  type = string
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type = string
}

variable "private_subnet_cidrs" {
  description = "list of private subnets CIDR blocks"
  type = list(string)
}
