terraform {
  backend "s3" {
    bucket         = "dev-bucket-047" # change this
    key            = "statefiles/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}