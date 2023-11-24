output "ec2_userdata_instance_info" {
  description = "Public IP address of the EC2 instance"
  value = {
    public_ip  = aws_instance.ec2_userdata.public_ip
    private_ip = aws_instance.ec2_userdata.private_ip
    pub_dns    = aws_instance.ec2_userdata.public_dns
    pri_dns    = aws_instance.ec2_userdata.private_dns
  }
}
output "ec2_provisinoer_instance_info" {
  description = "Public IP address of the EC2 instance"
  value = {
    public_ip  = aws_instance.ec2_provisinoer.public_ip
    private_ip = aws_instance.ec2_provisinoer.private_ip
    pub_dns    = aws_instance.ec2_provisinoer.public_dns
    pri_dns    = aws_instance.ec2_provisinoer.private_dns
  }
}

//null_resource
