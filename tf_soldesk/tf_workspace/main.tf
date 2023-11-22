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
