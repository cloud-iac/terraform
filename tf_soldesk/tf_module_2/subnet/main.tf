// Create a Subnet
resource "aws_subnet" "subnets" {
  for_each          = merge(var.subnets.pub_subnets, var.subnets.pri_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_${each.key}_sn"
  }
}