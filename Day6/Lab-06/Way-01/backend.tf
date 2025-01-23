terraform {
  backend "s3" {
    bucket = "dev-bucket-037"
    key = "statefiles/workspace"
    region = "ap-south-1"
    encrypt = true
  }
}