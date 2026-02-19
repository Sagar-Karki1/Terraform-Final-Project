variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

# Public Subnet CIDR blocks
variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Private Subnet CIDR blocks
variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

#availability zones
variable "availability_zones" {
    description = "List of availability zones to use for subnets"
    type        = list(string)
}

#environment
variable "env" {
  description = "Environment name"
  type        = string
}