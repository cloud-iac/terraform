variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
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
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}