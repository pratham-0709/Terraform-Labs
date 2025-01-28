variable "vault_addr" {
  description = "Vault server address"
  type        = string
}

variable "vault_role_id" {
  description = "Vault AppRole role_id"
  type        = string
  sensitive   = true
}

variable "vault_secret_id" {
  description = "Vault AppRole secret_id"
  type        = string
  sensitive   = true
}

variable "ami_value" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "Instance type for the EC2 instance"
  type        = string
}