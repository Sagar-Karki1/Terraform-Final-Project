variable "keypair_name" {
  description = "The name of the keypair to use for EC2 instances"
  type = string
}

variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type = string
}

variable "instance_type" {
  description = "The instance type to use for EC2 instances"
  type = string
}

variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type = string
}

variable "public_subnet_ids" {
  description = "List of the public subnets"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "List of the private subnets"
  type = list(string)
}

variable "webserver_sg_id" {
  description = "Webserver Security Group ID"
  type = string
}

variable "bastion_sg_id" {
  description = "Secuirty Group id for bastion host"
  type = string
}

variable "private_sg-id" {
  description = "Private security group ID"
  type = string
}

