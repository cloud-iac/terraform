terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "aws_ami" "amazon_linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

//create vpc
resource "aws_vpc" "tf_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = {
    Name = "tf_vpc"
  }
}

//create pub-subnet
resource "aws_subnet" "tf_pub_sn" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "tf_pub_sn"
  }
}

//create igw
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}

//create rt
resource "aws_route_table" "tf_pub_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "tf_pub_rt"
  }
}

//associate pub-rt to pub-sn
resource "aws_route_table_association" "tf_rt_ass" {
  subnet_id      = aws_subnet.tf_pub_sn.id
  route_table_id = aws_route_table.tf_pub_rt.id
}

//create security group
resource "aws_security_group" "tf_pub_sg" {
  name        = "tf_pub_sg"
  description = "allows http/s, ssh, icmp"
  vpc_id      = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_pub_sg"
  }
}

//create sg_rule ssh
resource "aws_security_group_rule" "tf_pub_sg_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_pub_sg.id
}

//create sg_rule http
resource "aws_security_group_rule" "tf_pub_sg_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_pub_sg.id
}

//create sg_rule https
resource "aws_security_group_rule" "tf_pub_sg_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_pub_sg.id
}

//create sg_rule icmp
resource "aws_security_group_rule" "tf_pub_sg_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_pub_sg.id
}

//create sg_rule egress
resource "aws_security_group_rule" "tf_pub_sg_egress" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_pub_sg.id
}

//create instance
resource "aws_instance" "tf_web" {
  ami           = data.aws_ami.amazon_linux2.image_id
  instance_type = "t2.micro"

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.tf_pub_sn.id
  vpc_security_group_ids      = [aws_security_group.tf_pub_sg.id]

  user_data = <<-EOT
  #!/bin/bash
  yum install -y httpd
  echo "<h1>Terraform TEST Web server~!</h1>" > /var/www/html/index.html
  systemctl start httpd
  EOT

  tags = {
    Name = "tf_web"
  }
}

