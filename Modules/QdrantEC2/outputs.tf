output "private_ip" {
  value = aws_instance.qdrant.private_ip
}

output "public_ip" {
  value = aws_instance.qdrant.public_ip
}
