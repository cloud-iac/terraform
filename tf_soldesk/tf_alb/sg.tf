//create security group
resource "aws_security_group" "tf_alb_sg" {
  name        = "tf_alb_sg"
  description = "allows http/s"
  vpc_id      = aws_vpc.tf_alb_vpc.id

  tags = {
    Name = "tf_alb_sg"
  }
}

//create sg_rule
resource "aws_security_group_rule" "tf_alb_sg_rule" {
  for_each          = var.alb_ports
  type              = each.value.type
  to_port           = each.key
  from_port         = each.key
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.tf_alb_sg.id
}

//create security group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "tf_ec2_sg"
  description = "allows http/s, ssh"
  vpc_id      = aws_vpc.tf_alb_vpc.id

  tags = {
    Name = "tf_ec2_sg"
  }
}

//create sg_rule
resource "aws_security_group_rule" "tf_ec2_sg_rule" {
  for_each          = var.ec2_ports
  type              = each.value.type
  to_port           = each.key
  from_port         = each.key
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.tf_ec2_sg.id
}