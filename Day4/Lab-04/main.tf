provider "aws" {
  region = "ap-south-1"
}

module "ec2_module" {
  source = "./modules/test-module"
  ami_value = "ami-0d2614eafc1b0e4d2"
  subnet_id_value = "subnet-09211d94bace0a331"
  instance_type_value = "t2.micro"
  bucket_value = "dev-bucket-047"
  aws_dynamodb_table_value = "terraform-lock"
}