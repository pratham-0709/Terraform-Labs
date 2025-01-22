# Generating Key Pair
resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Generating VPC
resource "aws_vpc" "test-vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Generating Subnets
resource "aws_subnet" "test-subnet-01" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = var.test-subnet-01.cidr_block
  availability_zone       = var.test-subnet-01.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "test-subnet-02" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = var.test-subnet-02.cidr_block
  availability_zone       = var.test-subnet-02.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "test-subnet-03" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = var.test-subnet-03.cidr_block
  availability_zone       = var.test-subnet-03.availability_zone
  map_public_ip_on_launch = true
}

# Generating IGW
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
}

#Generating Route Tables
resource "aws_route_table" "test-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
}

# Route Associastions
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.test-subnet-01.id
  route_table_id = aws_route_table.test-rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.test-subnet-02.id
  route_table_id = aws_route_table.test-rt.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.test-subnet-03.id
  route_table_id = aws_route_table.test-rt.id
}

# Creating Security Group
resource "aws_security_group" "test-sg" {
  name   = "test-sg"
  vpc_id = aws_vpc.test-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All ICMP - IPv4"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sg"
  }
}

# Creating Instance and setting connection..
resource "aws_instance" "test-server" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = aws_subnet.test-subnet-02.id
  key_name               = aws_key_pair.test.key_name
  vpc_security_group_ids = [aws_security_group.test-sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "/home/devadmin/Terraform-Labs/Day5/Lab-05/app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Remote Session Connected...'",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip",
      "sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-virtualenv",
      "chown -R ubuntu:ubuntu ~",
      "virtualenv venv",
      "ls -la",
      ". venv/bin/activate",
      "pip3 install flask",
      "pip3 show flask",
      "nohup python3 app.py > app.log 2>&1 &",
      "echo 'Flask app started in background'",
      "ps -ef | grep python"
    ]
  }
}
