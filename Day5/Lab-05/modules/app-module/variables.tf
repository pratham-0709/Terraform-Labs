variable "cidr" {
  description = "cidr values for vpc"
}

variable "test-subnet-01" {
  description = "Value for the subnet 1"
  type = object({
    cidr_block = string
    availability_zone = string
  })
}

variable "test-subnet-02" {
  description = "Value for the subnet 2"
  type = object({
    cidr_block = string
    availability_zone = string
  })
}

variable "test-subnet-03" {
  description = "Value for the subnet 3"
  type = object({
    cidr_block = string
    availability_zone = string
  })
}

variable "ami_value" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type_value" {
  description = "Instance type for the EC2 instance"
  type        = string
}

