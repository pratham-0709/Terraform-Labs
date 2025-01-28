output "public_ip" {
  value = aws_instance.test-server.public_ip
}

output "public_dns" {
  value = aws_instance.test-server.public_dns
}