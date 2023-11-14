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