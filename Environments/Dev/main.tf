# responsible for executing the proper modules 

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../Modules/Networking"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = "${var.aws_region}a"
}

# create ECR Repositories
module "containerRegistry" {
  source = "../../Modules/ECR"
  repository_name = "api-prompt"
}
module "containerRegistry_master" {
  source = "../../Modules/ECR"
  repository_name = "api-master"
}
module "containerRegistry_auth" {
  source = "../../Modules/ECR"
  repository_name = "api-auth"
}
module "containerRegistry_log" {
  source = "../../Modules/ECR"
  repository_name = "api-log"
}


# # create ECS Cluster
# module "ECSCluster" {
#   source = "../../Modules/ECS"
#   cluster_name = "budly-main-cluster"
# }

# # Security Group for ECS Service
# resource "aws_security_group" "ecs_service" {
#   name        = "ecs-service-sg"
#   description = "Allow HTTP traffic"
#   vpc_id      = module.networking.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # IAM Role for ECS Task
# resource "aws_iam_role" "ecs_task_role" {
#   name = "ecs-task-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # create ECS Services
# module "api-prompt-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id        = module.ECSCluster.cluster_id
#   service_name      = "api-prompt-service"
#   container_name    = "api-prompt-container"
#   container_image   = "nginx:latest" # Replace with your ECR image URL
#   container_port    = 80
#   cpu               = "256"
#   memory            = "512"
#   desired_count     = 1
#   subnets           = [module.networking.public_subnet_id]
#   security_groups   = [aws_security_group.ecs_service.id]
#   assign_public_ip  = true
#   aws_region        = var.aws_region
#   task_role_arn     = aws_iam_role.ecs_task_role.arn
#   target_group_arn  = null
# }
# module "api-log-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id        = module.ECSCluster.cluster_id
#   service_name      = "api-log-service"
#   container_name    = "api-log-container"
#   container_image   = "nginx:latest" # Replace with your ECR image URL
#   container_port    = 80
#   cpu               = "256"
#   memory            = "512"
#   desired_count     = 1
#   subnets           = [module.networking.public_subnet_id]
#   security_groups   = [aws_security_group.ecs_service.id]
#   assign_public_ip  = true
#   aws_region        = var.aws_region
#   task_role_arn     = aws_iam_role.ecs_task_role.arn
#   target_group_arn  = null
# }

# module "api-master-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id        = module.ECSCluster.cluster_id
#   service_name      = "api-master-service"
#   container_name    = "api-master-container"
#   container_image   = "nginx:latest" # Replace with your ECR image URL
#   container_port    = 80
#   cpu               = "256"
#   memory            = "512"
#   desired_count     = 1
#   subnets           = [module.networking.public_subnet_id]
#   security_groups   = [aws_security_group.ecs_service.id]
#   assign_public_ip  = true
#   aws_region        = var.aws_region
#   task_role_arn     = aws_iam_role.ecs_task_role.arn
#   target_group_arn  = null
# }

# module "api-auth-service" {
#   source = "../../Modules/ECS/Service"

#   cluster_id        = module.ECSCluster.cluster_id
#   service_name      = "api-auth-service"
#   container_name    = "api-auth-container"
#   container_image   = "nginx:latest" # Replace with your ECR image URL
#   container_port    = 80
#   cpu               = "256"
#   memory            = "512"
#   desired_count     = 1
#   subnets           = [module.networking.public_subnet_id]
#   security_groups   = [aws_security_group.ecs_service.id]
#   assign_public_ip  = true
#   aws_region        = var.aws_region
#   task_role_arn     = aws_iam_role.ecs_task_role.arn
#   target_group_arn  = null
# }

