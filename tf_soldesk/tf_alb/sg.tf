//create security group
resource "aws_security_group" "tf_alb_sg" {
  name        = "tf_alb_sg"
  description = "allows http/s"
  vpc_id      = aws_vpc.tf_alb_vpc.id

  tags = {
    Name = "tf_alb_sg"
  }
}
//create sg_rule http
resource "aws_security_group_rule" "tf_alb_sg_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_alb_sg.id
}

//create sg_rule https
resource "aws_security_group_rule" "tf_alb_sg_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_alb_sg.id
}

//create sg_rule egress
resource "aws_security_group_rule" "tf_alb_sg_egress" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_alb_sg.id
}