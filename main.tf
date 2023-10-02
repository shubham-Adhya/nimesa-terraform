# Defining the provider and region
provider "aws" {
  region = "us-east-1"
}

# Creating a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Creating a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # zone
  map_public_ip_on_launch = true
}

# Creating a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private_subnet"
  }
}

# Creating a security group
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-sg-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-12345678" # Change it to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "your-key-name" # Change it to your SSH key pair name

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name    = "Nimesa Assignment Instance"
    Purpose = "Assignment 1"
  }

  # Attaching the security group
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

