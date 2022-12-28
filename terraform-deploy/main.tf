terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id = "vpc-0ce75aaa035e86fae"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0dbc54a9e3f0f79d4"
  instance_type = "t2.micro"
  key_name = "AWS"

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id
  ]

  tags = {
    Name = var.instance_name
  }

  depends_on = [ aws_security_group.allow_ssh ]
  
}
