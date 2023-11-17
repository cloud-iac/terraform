# ALB 생성
resource "aws_lb" "tf_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_alb_sg.id]

  subnets = [
    aws_subnet.tf_subnets["pub_sn_1"].id,
    aws_subnet.tf_subnets["pub_sn_2"].id,
  ]

  # depends_on = [
  #   aws_instance.tf_alb_web,
  # ]

  tags = {
    Name = "app-tier-internal-lb"
  }
}

# ALB Target Group 생성
resource "aws_lb_target_group" "tf_alb-tg" {
  name     = "alb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_alb_vpc.id
  tags = {
    Name = "tf_alb-tg"
  }
}

# ALB listener 생성
resource "aws_lb_listener" "tf-alb-listner" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_alb-tg.arn
  }
}
# locals {
#   instances = [for o in aws_instance.tf_alb_web : o.id]
# }
# # # 대상그룹 연결
# resource "aws_lb_target_group_attachment" "tf_alb_tg_att" {
#   count            = 2
#   target_group_arn = aws_lb_target_group.tf_alb-tg.arn
#   target_id        = local.instances[count.index]
#   port             = 80
#   depends_on = [
#     aws_lb_listener.tf-alb-listner,
#   ]
# }