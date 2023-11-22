# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
  #   backend "s3" {
  #     bucket = "soldesk-tf-lundaljung"
  #     key    = "test/terraform.tfstate"
  #     region = "ap-northeast-2"
  #   }
    cloud {
      organization = "native_cloud"
      hostname = "app.terraform.io"
      
      workspaces {
        name = "tf-backend"
      }
    }
  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "native_cloud"

  #   workspaces {
  #     prefix = "first-terraform-backend"
  #   }
  # }
}

# Provider Block
provider "aws" {
  region = "ap-northeast-2"
}

variable "users" { type = list(any) }

resource "aws_iam_group" "group" {
  for_each = toset(["emp", "dev"])
  name = each.value
}

resource "aws_iam_user" "user" {
  for_each = {
    for user in var.users : user.name => user
  }
  name = each.key

  tags = each.value
}
resource "aws_iam_user_group_membership" "membership" {
  for_each = {
    for user in var.users : user.name => user
  }
  user = each.key

  groups = each.value.is_dev ? [aws_iam_group.group["dev"].name, aws_iam_group.group["emp"].name] : [aws_iam_group.group["emp"].name]

}
