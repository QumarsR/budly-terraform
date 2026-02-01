variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow the bucket to be destroyed even if it contains objects"
  type        = bool
}

variable "versioning_status" {
  description = "Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled"
  type        = string
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use. Valid values: AES256, aws:kms"
  type        = string
}

variable "kms_master_key_id" {
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. Only used if sse_algorithm is aws:kms"
  type        = string
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
}

