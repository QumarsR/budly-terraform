variable "cluster_id" {
  description = "ID of the ECS cluster to deploy the service into"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image to use for the container"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "cpu" {
  description = "CPU units for the task definition"
  type        = string
}

variable "memory" {
  description = "Memory for the task definition"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnets" {
  description = "Subnets for the ECS service"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the ECS tasks"
  type        = bool
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the IAM role that allows the ECS task to make calls to AWS services"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the Load Balancer target group"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
