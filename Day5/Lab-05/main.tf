provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

module "app-module" {
  source = "./modules/app-module"
  cidr = "10.53.0.0/16"
  ami_value = "ami-023a307f3d27ea427"
  instance_type_value = "t2.micro"
  test-subnet-01 = {
    cidr_block = "10.53.0.0/24"
    availability_zone = "ap-south-1a"
  }
  test-subnet-02 = {
    cidr_block = "10.53.1.0/24"
    availability_zone = "ap-south-1b"
  }
  test-subnet-03 = {
    cidr_block = "10.53.2.0/24"
    availability_zone = "ap-south-1c"
  }
}
