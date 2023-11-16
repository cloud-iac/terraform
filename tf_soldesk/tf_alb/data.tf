data "aws_subnets" "pubs" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pub_sn_1", "TF-ALB_pub_sn_2"]
  }
}
data "aws_subnets" "pris" {
  filter {
    name   = "tag:Name"
    values = ["TF-ALB_pri_sn_1", "TF-ALB_pri_sn_2"]
  }
}