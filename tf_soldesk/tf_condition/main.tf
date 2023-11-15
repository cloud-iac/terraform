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

# # condition ? True : False
# variable "test" {
#   type = bool
#   description = "True or False"
#   default = true
# }
# locals {
#   msg = var.test ? "참입니다." : "거짓입니다."
# }
# output "result" {
#   value = local.msg
# }

variable "igw_enabled" {
  type        = bool
  description = "True or False"
}

# vpc 생성
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}
# igw 생성
resource "aws_internet_gateway" "test_igw" {
  count  = var.igw_enabled ? 1 : 0
  vpc_id = aws_vpc.test_vpc.id
}