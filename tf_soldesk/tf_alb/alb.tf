# ALB 생성
resource "aws_lb" "tf_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_alb_sg.id]

  subnets = [
    data.aws_subnet.pub1.id,
    data.aws_subnet.pub2.id,
  ]

  depends_on = [
    aws_instance.tf_alb_web_1,
    aws_instance.tf_alb_web_2,
  ]

  tags = {
    Name = "app-tier-internal-lb"
  }
}

# ALB Target Groups
resource "aws_lb_target_group" "tf_alb-tg" {
  name        = "alb-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf_alb_vpc.id
  target_type = "instance"

  tags = {
    Name = "tf_alb-tg"
  }
}

# ALB listener
resource "aws_lb_listener" "tf-alb-listner" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_alb-tg.arn
  }
}

# 대상 그룹 연결
resource "aws_lb_target_group_attachment" "tf_alb_tg_att1" {
  target_group_arn = aws_lb_target_group.tf_alb-tg.arn
  target_id        = aws_instance.tf_alb_web_1.id
  port             = 80
  depends_on       = [aws_lb_listener.tf-alb-listner]
}
resource "aws_lb_target_group_attachment" "tf_alb_tg_att2" {
  target_group_arn = aws_lb_target_group.tf_alb-tg.arn
  target_id        = aws_instance.tf_alb_web_2.id
  port             = 80
  depends_on       = [aws_lb_listener.tf-alb-listner]
}