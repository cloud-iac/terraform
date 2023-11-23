provider "aws" {
  region = "ap-northeast-2"
}
module "vpc" {
  source     = "./vpc"
  pjt_name   = var.pjt_name
  cidr_block = var.vpc_cidr_block
}
module "subnet" {
  source   = "./subnet"
  pjt_name = var.pjt_name
  vpc_id   = module.vpc.vpc_id
  igw_id   = module.vpc.igw_id
  subnets  = var.subnets

}
output "outputs" {
  value = {
    vpc_id = module.vpc.vpc_id
    igw_id = module.vpc.igw_id
    subnet = module.subnet.subents
  }
}