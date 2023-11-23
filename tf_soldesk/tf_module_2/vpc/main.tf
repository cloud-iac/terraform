resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block == null ? "10.0.0.0/16" : null
  enable_dns_hostnames = true
  tags = {
    Name = "${var.pjt_name}_vpc"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.pjt_name}_igw"
  }
}