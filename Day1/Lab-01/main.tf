terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test-lab" {
  ami           = "ami-023a307f3d27ea427"
  instance_type = "t2.micro"
  subnet_id     = "subnet-09211d94bace0a331"
  key_name      = "bastion"
}
