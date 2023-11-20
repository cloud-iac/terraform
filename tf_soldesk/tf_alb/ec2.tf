# //create private instance 2개
# resource "aws_instance" "tf_alb_web" {
#   count         = 2
#   ami           = lookup(var.AMIS, var.AWS_REGION)
#   instance_type = "t2.micro"

#   associate_public_ip_address = false
#   subnet_id                   = aws_subnet.tf_subnets["pri_sn_${count.index + 1}"].id
#   vpc_security_group_ids      = [aws_security_group.tf_ec2_sg.id]

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

resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "tf_lc_"
  image_id                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  security_groups             = [aws_security_group.tf_ec2_sg.id]

  user_data = <<-EOT
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
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

//create private instance 2개
resource "aws_instance" "tf_bestion" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.tf_subnets["pub_sn_2"].id
  vpc_security_group_ids      = [aws_security_group.tf_ec2_sg.id]
  key_name = "tf_key"
  tags = {
    Name = "tf_bestion"
  }

  depends_on = [
    aws_internet_gateway.tf_alb_igw,
  ]
}
