# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.region
}

# Resource Block
// Create a VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.pjt_name}_vpc"
  }
}

// Create a Subnet
resource "aws_subnet" "tf_sn" {
  for_each          = merge(var.subnets.pub_subnets, var.subnets.pri_subnets)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_${each.key}_sn"
  }
}

// Create a Internet Gateway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.pjt_name}_igw"
  }
}

// Create a Public Route Table
resource "aws_route_table" "tf_pub_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "${var.pjt_name}_pub_rt"
  }
}

// Associate a Public Route Table With a Public Subnet
resource "aws_route_table_association" "tf_pub_rt_ass" {
  for_each       = var.subnets.pub_subnets
  subnet_id      = aws_subnet.tf_sn["${each.key}"].id
  route_table_id = aws_route_table.tf_pub_rt.id
}

// Create a Private Route Table
resource "aws_route_table" "tf_pri_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.pjt_name}_pri_rt"
  }
}

// Associate a Public Route Table With a Public Subnet
resource "aws_route_table_association" "tf_pri_rt_ass" {
  for_each       = var.subnets.pri_subnets
  subnet_id      = aws_subnet.tf_sn["${each.key}"].id
  route_table_id = aws_route_table.tf_pri_rt.id
}