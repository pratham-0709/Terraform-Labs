provider "aws" {
  region = "ap-south-1"
}

# Declare variables in the root module
variable "ami" {
  description = "AMI ID for the instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = map(string)

  default = {
    "dev" = "t2.micro",
    "stg" = "t2.medium",
    "prod" = "t3.micro"
  }

}

# Call the module and pass the variables
module "test-module" {
  source         = "./modules/test-module"
  ami            = var.ami
  instance_type  = lookup(var.instance_type,terraform.workspace,"t2.small")
}
