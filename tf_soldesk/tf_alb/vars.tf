variable "AWS_REGION" {
  default = "ap-northeast-2"
}
variable "AMIS" {
  type = map(string)
  default = {
    ap-northeast-1 = "ami-0e2e9a769def245c4"
    ap-northeast-2 = "ami-09e70258ddbdf3c90"
  }
}
variable "project_name" {
  default = "TF-ALB"
}
variable "subnets" {
  default = [
    {
      name                 = "pub_sn_1"
      cidr_block           = "10.0.1.0/24"
      availability_zone_id = "apne2-az1"
    },

    {
      name                 = "pub_sn_2"
      cidr_block           = "10.0.2.0/24"
      availability_zone_id = "apne2-az3"
    },

    {
      name                 = "pri_sn_1"
      cidr_block           = "10.0.3.0/24"
      availability_zone_id = "apne2-az1"
    },

    {
      name                 = "pri_sn_2"
      cidr_block           = "10.0.4.0/24"
      availability_zone_id = "apne2-az3"
    },
  ]
}
variable "alb_ports" {
  default = {
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