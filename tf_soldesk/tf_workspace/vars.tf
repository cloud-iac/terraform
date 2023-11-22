# Variable Block
variable "region" {}
variable "pjt_name" {}
variable "cidr_block" {}
variable "subnets" {
    type = map(any)
}

