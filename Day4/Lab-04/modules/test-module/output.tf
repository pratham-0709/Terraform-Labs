output "public-ipv4-addr" {
  value = aws_instance.test-server.public_ip
}

output "public-dns" {
  value = aws_instance.test-server.public_dns
}