data "vault_kv_secret_v2" "example" {
  mount = "kv" 
  name  = "test-secret" 
}

resource "aws_instance" "test-server" {
  ami           = var.ami_value
  instance_type = var.instance_type_value
  
  tags = {
    Env = data.vault_kv_secret_v2.example.data["Environment"]
  }
}