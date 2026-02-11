variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is KMS. Not used when encryption_type is AES256."
  type        = string
  default     = null
}

variable "enable_lifecycle_policy" {
  description = "Whether to enable the default lifecycle policy"
  type        = bool
  default     = false
}

variable "untagged_image_retention_days" {
  description = "Number of untagged images to keep (used when enable_lifecycle_policy is true)"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
