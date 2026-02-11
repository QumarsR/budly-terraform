resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = var.domain_name
  description = "Private DNS namespace for ECS service discovery"
  vpc         = var.vpc_id
}
