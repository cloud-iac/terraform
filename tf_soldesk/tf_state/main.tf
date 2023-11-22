# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
  backend "s3" {
    bucket = "soldesk-tf-lundaljung"
    key    = "test/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# Provider Block
provider "aws" {
  region = "ap-northeast-2"
}

# Variable Block
variable "pjt_name" {
  default = "tf_project"
}

# Resource Block
// Create a VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.pjt_name}_vpc"
  }
}

// Create a Internet Gateway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.pjt_name}_igw"
  }
}

// Create a Subnet
resource "aws_subnet" "tf_pub_sn" {
  for_each = {
    "10.0.1.0/24" = "ap-northeast-2a"
    "10.0.2.0/24" = "ap-northeast-2c"
  }
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_pub_sn"
  }
}

resource "aws_subnet" "tf_pri_sn" {
  for_each = {
    "10.0.3.0/24" = "ap-northeast-2a"
    "10.0.4.0/24" = "ap-northeast-2c"
  }
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_pri_sn"
  }
}
