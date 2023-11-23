provider "aws" {
  region = "ap-northeast-2"
}
module "vpc" {
  source     = "./vpc"
  pjt_name   = "test"
  cidr_block = "172.16.0.0/16"
}
module "subnet" {
  source = "./subnet"
  pjt_name   = "test"
  vpc_id = module.vpc.vpc_id
}
output "outputs" {
  value = {
    vpc_id = module.vpc.vpc_id
    igw_id = module.vpc.igw_id
    subnet = module.subnet.subents
  }
}