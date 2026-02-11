output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.main.id
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}
