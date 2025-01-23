terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

variable "ami" {
  description = "ami value "
}

variable "instance_type" {
  description = "instance type value"
}

resource "aws_instance" "test-server" {
  ami = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "web - ${terraform.workspace}"
  }
}