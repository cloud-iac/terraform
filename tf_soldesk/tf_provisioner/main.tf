#default vpc
resource "aws_default_vpc" "vpc" {}

#security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "allows http/s, ssh"
  vpc_id      = aws_default_vpc.vpc.id

  tags = {
    Name = "ec2_sg"
  }
}

#sg_rule
resource "aws_security_group_rule" "ec2_sg_rule" {
  for_each          = var.ec2_ports
  type              = each.value.type
  to_port           = each.key
  from_port         = each.key
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.ec2_sg.id
}

#EC2 using userdata
resource "aws_instance" "ec2_userdata" {
  ami                         = lookup(var.AMIS, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tf_key"
  subnet_id                   = "subnet-0659ddae3aeefa21c"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  user_data = <<EOT
  #!/bin/bash
  yum update  
  yum install -y httpd
  echo "<h1>Userdata EC2</h1>" >> /var/www/html/index.html
  systemctl start httpd
  systemctl enable httpd
  EOT

  tags = {
    Name = "ec2_userdata"
  }
}

#EC2 using provisioner
resource "aws_instance" "ec2_provisinoer" {
  ami                         = lookup(var.AMIS, var.region)
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tf_key"
  subnet_id                   = "subnet-0659ddae3aeefa21c"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  user_data = <<EOT
  #!/bin/bash
  echo "p@ssw0rd" | passwd --stdin root
  sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
  sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
  EOT

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      password = "p@ssw0rd"
      host        = self.public_ip
      timeout     = "1m"
    }
    inline = [
      "yum install -y httpd",
      "systemctl start httpd",
      "systemctl enable httpd"
    ]
  }

  tags = {
    Name = "ec2_provisinoer"
  }
}

resource "null_resource" "ec2_provisinoer" {
  triggers = {
    instance_id = aws_instance.ec2_provisinoer.id
    index_html  = filemd5("${path.module}/files/index.html")
  }
  provisioner "file" {
    source      = "${path.module}/files/index.html"
    destination = "/var/www/html/index.html"
    connection {
      type        = "ssh"
      user        = "root"
      password = "p@ssw0rd"
      host        = aws_instance.ec2_provisinoer.public_ip
      timeout     = "1m"
    }
  }
}