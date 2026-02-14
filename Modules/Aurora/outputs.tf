output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "cluster_id" {
  description = "The cluster ID"
  value       = aws_rds_cluster.main.id
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.main.database_name
}

output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = aws_security_group.aurora.id
}

output "secret_arn" {
  description = "The ARN of the secret in Secrets Manager (if generated), contains the admin password"
  value       = var.master_password == null ? aws_secretsmanager_secret.aurora_credentials[0].arn : null
}
