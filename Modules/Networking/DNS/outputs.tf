output "namespace_id" {
  description = "The ID of the private DNS namespace"
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "namespace_arn" {
  description = "The ARN of the private DNS namespace"
  value       = aws_service_discovery_private_dns_namespace.main.arn
}

output "namespace_name" {
  description = "The name of the private DNS namespace"
  value       = aws_service_discovery_private_dns_namespace.main.name
}
