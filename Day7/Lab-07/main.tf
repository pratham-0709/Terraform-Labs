provider "aws" {
  region = "ap-south-1"
}

module "test" {
  source = "./modules/test-module"
  vault_addr = var.vault_addr
  vault_role_id = var.vault_role_id
  vault_secret_id = var.vault_secret_id
  instance_type_value = var.instance_type_value
  ami_value = var.ami_value
}