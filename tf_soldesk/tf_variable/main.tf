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

# variable "project_name" {
#   description = "Project Name(프로젝트 이름)? "
#   default = "tf"
# }

locals {
  common_tags = {
    Name    = "TEST-VPC"
    Service = "network"
    Owner   = "lundaljung"
  }
}

resource "aws_vpc" "tf_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = local.common_tags
}
