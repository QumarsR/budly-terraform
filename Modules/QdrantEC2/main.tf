data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "qdrant" {
  name        = "qdrant-sg"
  description = "Allow Qdrant traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6333
    to_port         = 6333
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  ingress {
    from_port       = 6334
    to_port         = 6334
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "qdrant" {
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.qdrant.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 6333:6333 -p 6334:6334 \
                -v /qdrant_storage:/qdrant/storage \
                --restart always \
                qdrant/qdrant:latest
              EOF

  tags = {
    Name = "Qdrant-Instance"
  }
}
