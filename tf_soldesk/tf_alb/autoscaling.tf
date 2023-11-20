resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "tf_lc_"
  image_id                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.tf_alb_sg.id]

  user_data = <<-EOT
  #!/bin/bash
  yum install -y httpd php mysql php-mysql
  systemctl start httpd & systemctl enable httpd
  cd /var/www/html
  wget https://github.com/NetidCloud/soldesk/raw/main/rds.tar.gz
  tar xfz rds.tar.gz
  chown apache.root ./rds.conf.php
  yum update -y
#   yum update -y
#   yum install -y httpd 
#   systemctl start httpd
#   systemctl enable httpd
#   echo "<h1>Terraform TEST Web server from $(hostname) ~!</h1>" >> /var/www/html/index.html
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tf_asg" {
  name = "tf_asg"

  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier = [
    aws_subnet.tf_subnets["pri_sn_1"].id,
    aws_subnet.tf_subnets["pri_sn_2"].id,
  ]

  target_group_arns = [aws_lb_target_group.tf_alb-tg.arn]
  health_check_type = "ELB"

  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 10
  health_check_grace_period = 300
  force_delete              = true

  depends_on = [aws_nat_gateway.tf_alb_nat_gateway]
}
# scale up alarm
resource "aws_autoscaling_policy" "tf_asg-cpu-policy" {
  name                   = "tf_asg-cpu-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.tf_asg.name
}

resource "aws_cloudwatch_metric_alarm" "tf_asg-cpu-alarm" {
  alarm_name          = "tf_asg-cpu-alarm"
  alarm_description   = "tf_asg-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 80
  metric_name         = "CPUCheck"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.tf_asg.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.tf_asg-cpu-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "tf_asg-cpu-policy-scaledown" {
  name                   = "tf_asg-cpu-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.tf_asg.name
}

resource "aws_cloudwatch_metric_alarm" "tf_asg-cpu-alarm-scaledown" {
  alarm_name          = "example-cpu-alarm-scaledown"
  alarm_description   = "example-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 50
  metric_name         = "CPUCheck"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.tf_asg.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.tf_asg-cpu-policy-scaledown.arn]
}