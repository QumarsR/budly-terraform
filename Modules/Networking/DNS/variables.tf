variable "vpc_id" {
  description = "The ID of the VPC where the private namespace will be created"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the private namespace (e.g., budly.local)"
  type        = string
  default     = "budly.local"
}
