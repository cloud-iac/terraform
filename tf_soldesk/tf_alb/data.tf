data "aws_subnet" "pub1" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pub_sn_1"]
  }
  depends_on = [aws_subnet.tf_subnets]
}
data "aws_subnet" "pub2" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pub_sn_2"]
  }
  depends_on = [aws_subnet.tf_subnets]
}
data "aws_subnet" "pri1" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pri_sn_1"]
  }
  depends_on = [aws_subnet.tf_subnets]
}
data "aws_subnet" "pri2" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pri_sn_2"]
  }
  depends_on = [aws_subnet.tf_subnets]
}