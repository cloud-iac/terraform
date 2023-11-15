terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }
}

provider "aws" {}

resource "aws_iam_group" "developers" {
  name = "developers"
}
resource "aws_iam_group" "analyst" {
  name = "analyst"
}
#user생성
resource "aws_iam_user" "users" {
  for_each = {
    for user in var.users : user.name => user 
  }
  name = each.key
  tags = {
    levle = each.value.level
    role = each.value.role
  }
}

# 사용자 그룹에 사용자 소속
resource "aws_iam_user_group_membership" "team" {
  for_each = {
    for user in var.users : user.name => user 
  }
  user = each.key

  groups = each.value.is_dev ? [aws_iam_group.developers.name] : [aws_iam_group.analyst.name]
}

# dev 사용자 그룹에 정책 할당
locals {
  dev = [for user in var.users : user if user.is_dev]
}

resource "aws_iam_user_policy_attachment" "dev_att" {
  for_each = {
    for user in local.dev : user.name => user
  }
  user = each.key
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "deleoper" {
  value = [for user in var.users : user.name if user.level >= 5]
}