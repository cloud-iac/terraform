//create instance1
resource "aws_instance" "tf_alb_web_1" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  associate_public_ip_address = false
  subnet_id                   = data.aws_subnets.pris.ids[0]
  vpc_security_group_ids      = [aws_security_group.tf_alb_sg.id]

  user_data = <<-EOT
  #!/bin/bash
  yum install -y httpd
  echo "<h1>Terraform TEST Web server 1 ~!</h1>" > /var/www/html/index.html
  systemctl start httpd
  EOT

  tags = {
    Name = "tf_alb_web_1"
  }
  depends_on = [aws_nat_gateway.tf_alb_nat_gateway]
}

//create instance2
resource "aws_instance" "tf_alb_web_2" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  associate_public_ip_address = false
  subnet_id                   = data.aws_subnets.pris.ids[1]
  vpc_security_group_ids      = [aws_security_group.tf_alb_sg.id]

  user_data = <<-EOT
  #!/bin/bash
  yum install -y httpd
  echo "<h1>Terraform TEST Web server 2 ~!</h1>" > /var/www/html/index.html
  systemctl start httpd
  EOT

  tags = {
    Name = "tf_alb_web_2"
  }
  depends_on = [aws_nat_gateway.tf_alb_nat_gateway]
}