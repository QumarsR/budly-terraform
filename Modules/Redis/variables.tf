variable "subnet_group_name" {
  description = "The name of the ElastiCache subnet group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security groups allowed to access Redis"
  type        = list(string)
}
