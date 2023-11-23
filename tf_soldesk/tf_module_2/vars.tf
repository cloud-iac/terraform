variable "pjt_name" {
  default = "test"
}
variable "subnets" {
  default = {
    pub_subnets = {
      "172.16.0.0/24" = "ap-northeast-2a"
      "172.16.1.0/24" = "ap-northeast-2c"
    },
    pri_subnets = {
      "172.16.3.0/24" = "ap-northeast-2a"
      "172.16.4.0/24" = "ap-northeast-2c"
    },
  }
}
variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}