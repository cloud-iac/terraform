variable "region" {
  default = "ap-northeast-2"
}
variable "AMIS" {
  type = map(string)
  default = {
    ap-northeast-1 = "ami-0e2e9a769def245c4"
    ap-northeast-2 = "ami-09e70258ddbdf3c90"
  }
}
variable "ec2_ports" {
  default = {
    22 = {
      type       = "ingress"
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    }
    80 = {
      type       = "ingress"
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    443 = {
      type       = "ingress"
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    }
    0 = {
      type       = "egress"
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    }
  }
}

