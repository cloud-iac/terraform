# //create instance 2개
# resource "aws_instance" "tf_alb_web" {
#   count         = 2
#   ami           = lookup(var.AMIS, var.AWS_REGION)
#   instance_type = "t2.micro"

#   associate_public_ip_address = false
#   subnet_id                   = aws_subnet.tf_subnets["pri_sn_${count.index + 1}"].id
#   vpc_security_group_ids      = [aws_security_group.tf_alb_sg.id]

#   user_data = <<-EOT
#   #!/bin/bash
#   yum update -y
#   yum install -y httpd
#   systemctl start httpd
#   systemctl enable httpd
#   echo "<h1>Terraform TEST Web server from $(hostname) ~!</h1>" > /var/www/html/index.html
#   EOT
#   tags = {
#     Name = "tf_alb_web_${count.index + 1}"
#   }

#   depends_on = [
#     aws_nat_gateway.tf_alb_nat_gateway,
#   ]
# }

#Elastic ip
resource "aws_eip" "tf_alb_eip" {
  domain = "vpc"
}