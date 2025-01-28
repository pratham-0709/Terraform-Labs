output "public-ipv4-addr" {
  value = module.test.public_ip
}

output "public-dns" {
  value = module.test.public_dns
}