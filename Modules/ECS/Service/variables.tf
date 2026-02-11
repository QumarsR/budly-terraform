variable "cluster_id" {
  description = "ID of the ECS cluster to deploy the service into"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition to use for the service"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
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

variable "target_group_arn" {
  description = "ARN of the Load Balancer target group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "service_discovery_namespace_id" {
  description = "The ID of the private DNS namespace"
  type        = string
}

variable "service_discovery_name" {
  description = "The name of the service record (e.g., auth, log)"
  type        = string
}
