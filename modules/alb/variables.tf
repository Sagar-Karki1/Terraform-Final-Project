variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "env" {
  description = "Environment name"
  type = string
}

variable "instance_ids" {
  type = list(string)
  description = "List of EC2 instance IDs to attach to a target group"
}

variable "alb_sg_id" {
  type = string
  description = "Security group for alb"
}