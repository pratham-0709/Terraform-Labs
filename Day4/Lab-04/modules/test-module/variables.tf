variable "ami_value" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_id_value" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "bucket_value" {
  description = "S3 bucket name"
  type        = string
}

variable "aws_dynamodb_table_value" {
  description = "DynamoDB table name"
  type        = string
}