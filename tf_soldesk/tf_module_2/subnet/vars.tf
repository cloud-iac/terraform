variable "region" { default = "ap-northeast-2" }
variable "pjt_name" { default = "demo_module" }
variable "vpc_id" { default = null}
variable "subnets" {
  default = {
    pub_subnets = {
      "10.1.1.0/24" = "ap-northeast-2a"
      "10.1.2.0/24" = "ap-northeast-2c"
    },
    pri_subnets = {
      "10.1.3.0/24" = "ap-northeast-2a"
      "10.1.4.0/24" = "ap-northeast-2c"
    },
  }
}
