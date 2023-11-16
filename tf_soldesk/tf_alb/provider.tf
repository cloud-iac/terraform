provider "aws" {
  region = var.AWS_REGION
}


output "test1" {
  value = data.aws_subnet.pub1.id
}
output "test2" {
  value = data.aws_subnet.pub2.id
}
output "test3" {
  value = data.aws_subnet.pri1.id
}
output "test4" {
  value = data.aws_subnet.pri2.id
}