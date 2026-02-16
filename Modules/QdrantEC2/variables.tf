variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the instance in"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security groups allowed to access Qdrant"
  type        = list(string)
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = null
}

variable "ami_id" {
  description = "The AMI ID to use"
  type        = string
  default     = null
}

variable "ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
