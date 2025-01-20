# Define the VPC
resource "aws_vpc" "test-vpc" {
  cidr_block = var.cidr
}

# Define Subnets
resource "aws_subnet" "test-subnet-01" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = "10.52.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "test-subnet-02" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = "10.52.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "test-subnet-03" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = "10.52.2.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true
}

# Define the Internet Gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.test-vpc.id
}

# Define the Route Table
resource "aws_route_table" "test-rt" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }
}

# Associate Route Table with Subnets
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

# Define Security Group
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

# S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "tedevterraform2025project"
}

# EC2 Instances
resource "aws_instance" "webserver1" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id              = aws_subnet.test-subnet-02.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id              = aws_subnet.test-subnet-02.id
  user_data              = base64encode(file("userdata1.sh"))
}

# Create ALB
resource "aws_lb" "test-alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.test-sg.id]
  subnets         = [
    aws_subnet.test-subnet-01.id,
    aws_subnet.test-subnet-02.id,
    aws_subnet.test-subnet-03.id
  ]

  tags = {
    Name = "web"
  }
}

# Target Group
resource "aws_lb_target_group" "test-tg" {
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attach Instances to Target Group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "test-listener" {
  load_balancer_arn = aws_lb.test-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.test-tg.arn
    type             = "forward"
  }
}

# Output the Load Balancer DNS Name
output "loadbalancerdns" {
  value = aws_lb.test-alb.dns_name
}
