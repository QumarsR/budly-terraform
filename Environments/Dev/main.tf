# responsible for executing the proper modules 

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../Modules/Networking/VPC"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = "${var.aws_region}a"
}

# create private namesapce for container discovery
module "dns" {
  source = "../../Modules/Networking/DNS"

  vpc_id = module.networking.vpc_id
}

# create ECR Repositories
module "containerRegistry" {
  source          = "../../Modules/ECR"
  repository_name = "api-prompt"
}
module "containerRegistry_master" {
  source          = "../../Modules/ECR"
  repository_name = "api-master"
}
module "containerRegistry_auth" {
  source          = "../../Modules/ECR"
  repository_name = "api-auth"
}
module "containerRegistry_log" {
  source          = "../../Modules/ECR"
  repository_name = "api-log"
}


# create ECS Cluster
module "ECSCluster" {
  source       = "../../Modules/ECS"
  cluster_name = "budly-main-cluster"
}

# Security Group for ECS Services
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs-tasks-sg"
  description = "Allow inbound access on port 8000 from VPC"
  vpc_id      = module.networking.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Task Definitions

module "api-auth-td" {
  source          = "../../Modules/ECS/TaskDefinition"
  service_name    = "api-auth"
  container_name  = "api-auth-container"
  container_image = module.containerRegistry_auth.repository_url
  container_port  = 8000
  cpu             = "256"
  memory          = "512"
  aws_region      = var.aws_region
  task_role_arn   = aws_iam_role.ecs_task_role.arn
  environment_variables = [
    { name = "SERVER_IP", value = var.db_host },
    { name = "LOG_API", value = "http://log.budly.local:8000" },
    { name = "MODE_SERVER", value = "DEV" }
  ]
}

module "api-log-td" {
  source          = "../../Modules/ECS/TaskDefinition"
  service_name    = "api-log"
  container_name  = "api-log-container"
  container_image = module.containerRegistry_log.repository_url
  container_port  = 8000
  cpu             = "256"
  memory          = "512"
  aws_region      = var.aws_region
  task_role_arn   = aws_iam_role.ecs_task_role.arn
  environment_variables = [
    { name = "SERVER_IP", value = var.db_host },
    { name = "MODE_SERVER", value = "DEV" }
  ]
}

module "api-master-td" {
  source          = "../../Modules/ECS/TaskDefinition"
  service_name    = "api-master"
  container_name  = "api-master-container"
  container_image = module.containerRegistry_master.repository_url
  container_port  = 8000
  cpu             = "256"
  memory          = "512"
  aws_region      = var.aws_region
  task_role_arn   = aws_iam_role.ecs_task_role.arn
  environment_variables = [
    { name = "URL_API_AUTH", value = "http://auth.budly.local:8000" },
    { name = "URL_API_LOG", value = "http://log.budly.local:8000" },
    { name = "URL_API_CHAT", value = "http://prompt.budly.local:8000" },
    { name = "SERVER_IP", value = var.db_host },
    { name = "MODE_SERVER", value = "DEV" }
  ]
}

module "api-prompt-td" {
  source          = "../../Modules/ECS/TaskDefinition"
  service_name    = "api-prompt"
  container_name  = "api-prompt-container"
  container_image = module.containerRegistry.repository_url
  container_port  = 8000
  cpu             = "256"
  memory          = "512"
  aws_region      = var.aws_region
  task_role_arn   = aws_iam_role.ecs_task_role.arn
  environment_variables = [
    { name = "URL_API_AUTH", value = "http://auth.budly.local:8000" },
    { name = "URL_API_LOG", value = "http://log.budly.local:8000" },
    { name = "SERVER_API_IP", value = var.db_host },
    { name = "MODE_SERVER", value = "DEV" }
  ]
}

# # # create ECS Services
# module "api-prompt-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id          = module.ECSCluster.cluster_id
#   service_name        = "api-prompt-service"
#   container_name      = "api-prompt-container"
#   container_port      = 8000
#   desired_count       = 1
#   subnets             = [module.networking.public_subnet_id]
#   security_groups     = [aws_security_group.ecs_tasks_sg.id]
#   assign_public_ip    = true
#   task_definition_arn = module.api-prompt-td.arn
#   target_group_arn    = null

#   service_discovery_namespace_id = module.dns.namespace_id
#   service_discovery_name         = "prompt"
# }

# module "api-log-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id          = module.ECSCluster.cluster_id
#   service_name        = "api-log-service"
#   container_name      = "api-log-container"
#   container_port      = 8000
#   desired_count       = 1
#   subnets             = [module.networking.public_subnet_id]
#   security_groups     = [aws_security_group.ecs_tasks_sg.id]
#   assign_public_ip    = true
#   task_definition_arn = module.api-log-td.arn
#   target_group_arn    = null

#   service_discovery_namespace_id = module.dns.namespace_id
#   service_discovery_name         = "log"
# }

# module "api-master-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id          = module.ECSCluster.cluster_id
#   service_name        = "api-master-service"
#   container_name      = "api-master-container"
#   container_port      = 8000
#   desired_count       = 1
#   subnets             = [module.networking.public_subnet_id]
#   security_groups     = [aws_security_group.ecs_tasks_sg.id]
#   assign_public_ip    = true
#   task_definition_arn = module.api-master-td.arn
#   target_group_arn    = null

#   service_discovery_namespace_id = module.dns.namespace_id
#   service_discovery_name         = "master"
# }

# module "api-auth-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id          = module.ECSCluster.cluster_id
#   service_name        = "api-auth-service"
#   container_name      = "api-auth-container"
#   container_port      = 8000
#   desired_count       = 1
#   subnets             = [module.networking.public_subnet_id]
#   security_groups     = [aws_security_group.ecs_tasks_sg.id]
#   assign_public_ip    = true
#   task_definition_arn = module.api-auth-td.arn
#   target_group_arn    = null

#   service_discovery_namespace_id = module.dns.namespace_id
#   service_discovery_name         = "auth"
# }
