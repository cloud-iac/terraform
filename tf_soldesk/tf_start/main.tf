#테라폼 블럭
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

#프로바이더 블럭
provider "local" {
}

#리소스 블럭(쓰기)
resource "local_file" "foo" {
  content  = "Hello! Terraform~~!!"
  filename = "${path.module}/foo.txt"
}

#데이터 블럭(읽기)
data "local_file" "test" {
  filename = "${path.module}/foo.txt"
}

#아웃풋 블럭
output "file_test" {
  value = data.local_file.test
}

#AWS 프로바이더 블럭
provider "aws" {
  region = "ap-northeast-2"
}

#리소스 블럭
//Create a VPC
resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test_vpc"
  }
}

#아웃풋 블럭
output "test_vpc" {
  value = aws_vpc.test_vpc
}

#데이터 블럭
data "aws_vpcs" "test_vpc" {
}

#아웃풋 블럭
output "vpc_output_test" {
  value = data.aws_vpcs.test_vpc
}