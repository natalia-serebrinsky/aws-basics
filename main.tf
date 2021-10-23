provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

  resource "aws_security_group" "allow_webapp_traffic" {
  name        = "allow_webapp_traffic"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "allow_my_laptop"
  }
}

resource "aws_instance" "app_server" {

  count = 2
  ami           = "ami-066c743e93ec97f1d"
  instance_type = "t2.micro"
  key_name = "test-key-pair"
  associate_public_ip_address = true

  root_block_device {
    volume_size    = 10
    volume_type    = "gp2"
    encrypted      = false

  }

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = true
  }

  user_data = "${file("user-data-nginx.sh")}"

  vpc_security_group_ids = [aws_security_group.allow_webapp_traffic.id]

  tags = {
    Owner = "whiskey"
    Server_name = "whiskey"
    Purpose = "whiskey"
  }
}