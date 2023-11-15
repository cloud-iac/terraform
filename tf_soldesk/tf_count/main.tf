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

# #사용자 계정생성
# resource "aws_iam_user" "user_1" {
#   name = "user_1"
# }
# #사용자 계정생성
# resource "aws_iam_user" "user_2" {
#   name = "user_2"
# }
# #사용자 계정생성
# resource "aws_iam_user" "user_3" {
#   name = "user_3"
# }

# output "user_arn" {
#   value = [
#     aws_iam_user.user_1.arn,
#     aws_iam_user.user_2.arn,
#     aws_iam_user.user_3.arn,
#   ]
# }

# # count Meta 인자
# // admin 3명, dev 3명
# resource "aws_iam_user" "admin_users" {
#   count = 3
#   name = "admin_${count.index}"
# }

# resource "aws_iam_user" "dev_users" {
#   count = 3
#   name = "dev_${count.index}"
# }

# output "all_users_arn" {
#   value = {
#     admin = aws_iam_user.admin_users.*.arn,
#     dev = aws_iam_user.dev_users.*.arn
#   }
# }

# //VPC 3개(10.0.0.0/16, 10.1.0.0/16 10.2.0.0/16)
# resource "aws_vpc" "count_vpc" {
#   count = 3
#   cidr_block = "10.${count.index}.0.0/16"
#   tags = {
#     Name = "test_vpc_${count.index}"
#   }
# }

# #for_each
# resource "aws_iam_user" "for_each_users" {
#   for_each = toset([
#     "for_each_user_1",
#     "for_each_user_2",
#     "for_each_user_3",
#   ])
#   name = each.value
# }
# output "for_each_users" {
#   value = values(aws_iam_user.for_each_users).*.arn
# }

# //VPC 3개(10.0.0.0/16, 10.1.0.0/16 10.2.0.0/16)
# resource "aws_vpc" "for_each_vpc" {
#   for_each = toset([
#     "10.10.0.0/16",
#     "172.16.0.0/16",
#     "192.168.0.0/16",
#   ])
#   cidr_block = each.value
#   tags = {
#     Name = "test_vpc_${each.key}"
#   }
# }

# output "for_each_vpcs" {
#   value = values(aws_vpc.for_each_vpc).*.id
# }

# for_each와 map
resource "aws_iam_user" "for_each_map_users" {
  for_each = {
    kim = {
      Name = "kim"
      Level = "L"
      Dept = "Admin" 
    }
    lee = {
      Name = "lee"
      Level = "H"
      Dept = "Dev" 
    }
    park = {
      Name = "lee"
      Level = "H"
      Dept = "Dev" 
    }
  }
  name = each.key
  tags = each.value
}
output "for_each_map_users" {
  value = values(aws_iam_user.for_each_map_users).*.arn
}
