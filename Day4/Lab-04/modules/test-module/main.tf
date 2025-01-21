resource "aws_instance" "test-server" {
  ami           = var.ami_value
  instance_type = var.instance_type_value
  subnet_id     = var.subnet_id_value
}

resource "aws_s3_bucket" "dev-bucket-047" {
  bucket = var.bucket_value
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.aws_dynamodb_table_value
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}