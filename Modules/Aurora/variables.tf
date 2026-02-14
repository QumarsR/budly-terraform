variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the Aurora cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group (must cover at least 2 AZs)"
  type        = list(string)
}

variable "cluster_identifier" {
  description = "The identifier for the RDS cluster"
  type        = string
  default     = "budly-aurora-cluster"
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
  default     = "budly_db"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Password for the master DB user. If not provided, a random password will be generated and stored in Secrets Manager."
  type        = string
  sensitive   = true
  default     = null
}

variable "min_capacity" {
  description = "Minimum ACU for Aurora Serverless v2 scaling"
  type        = number
  default     = 0.5
}

variable "max_capacity" {
  description = "Maximum ACU for Aurora Serverless v2 scaling"
  type        = number
  default     = 2.0
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
