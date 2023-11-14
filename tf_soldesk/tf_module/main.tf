terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.25.0"
    }
  }
}
provider "aws" {
  region = "ap-northeast-2"
}
variable "project_name" {
  default = "tf_module"
}
locals {
  common_tags = {
    Name = "${var.project_name}"
  }
}
module "vpc" {
  source  = "tedilabs/network/aws//modules/vpc"
  version = "0.24.0"

  name       = "${var.project_name}_vpc"
  cidr_block = "10.0.0.0/16"
  dns_hostnames_enabled = true
  internet_gateway_enabled = true

  tags = local.common_tags
}

module "subnet_group" {
  source  = "tedilabs/network/aws//modules/subnet-group"
  version = "0.24.0"
  
  name = "${var.project_name}_pub_sn"
  subnets = {
    tf_module_pub_sn1 = {
        cidr_block = "10.0.0.0/24"
        availability_zone_id = "apne2-az1"
    }
    tf_module_pub_sn2 = {
        cidr_block = "10.0.1.0/24"
        availability_zone_id = "apne2-az3"
    }
  }
  vpc_id = module.vpc.id
}

module "route-table" {
  source  = "tedilabs/network/aws//modules/route-table"
  version = "0.31.0"
  
  name = "${var.project_name}_pub_rt"
  vpc_id = module.vpc.id

  ipv4_routes = [
    {
      destination = "0.0.0.0/0"
      target = {
        type = "INTERNET_GATEWAY"
        id = module.vpc.internet_gateway_id
      }
    }
  ]
  subnets = module.subnet_group.ids
  tags = local.common_tags
}
