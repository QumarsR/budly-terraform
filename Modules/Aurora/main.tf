resource "random_password" "master" {
  count   = var.master_password == null ? 1 : 0
  length  = 16
  special = false # Aurora sometimes has issues with certain special chars, safer to disable or limit
}

locals {
  master_password = var.master_password != null ? var.master_password : random_password.master[0].result
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name        = "${var.environment}-aurora-subnet-group"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_security_group" "aurora" {
  name        = "${var.environment}-aurora-sg"
  description = "Security group for Aurora cluster"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_groups
    content {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_cidrs
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "${var.environment}-aurora-sg"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_rds_cluster" "main" {
  cluster_identifier     = "${var.environment}-${var.cluster_identifier}"
  engine                 = "aurora-mysql"
  engine_mode            = "provisioned"
  engine_version         = "8.0.mysql_aurora.3.04.0"
  database_name          = var.database_name
  master_username        = var.master_username
  master_password        = local.master_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  skip_final_snapshot    = true
  storage_encrypted      = true

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }

  tags = merge(
    {
      Name        = "${var.environment}-aurora-cluster"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "main" {
  count              = 1
  identifier         = "${var.environment}-${var.cluster_identifier}-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version

  tags = merge(
    {
      Name        = "${var.environment}-aurora-instance-${count.index}"
      Environment = var.environment
    },
    var.tags
  )
}

# Store password in Secrets Manager if generated
resource "aws_secretsmanager_secret" "aurora_credentials" {
  count = var.master_password == null ? 1 : 0
  name  = "${var.environment}/aurora/${var.cluster_identifier}/creds"

  tags = merge(
    {
      Name        = "${var.environment}-aurora-creds"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "aurora_credentials" {
  count     = var.master_password == null ? 1 : 0
  secret_id = aws_secretsmanager_secret.aurora_credentials[0].id
  secret_string = jsonencode({
    username = var.master_username
    password = local.master_password
    engine   = "aurora-mysql"
    host     = aws_rds_cluster.main.endpoint
    port     = 3306
    dbname   = var.database_name
  })
}
