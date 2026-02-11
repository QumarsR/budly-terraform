### ECR Module - Repository for Docker Images

resource "aws_ecr_repository" "main" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key : null
  }

  tags = var.tags
}

# Lifecycle policy to clean up old images
resource "aws_ecr_lifecycle_policy" "main" {
  count      = var.enable_lifecycle_policy ? 1 : 0
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.untagged_image_retention_days} untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.untagged_image_retention_days
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

