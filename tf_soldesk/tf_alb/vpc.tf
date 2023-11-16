#VPC
resource "aws_vpc" "tf_alb_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}_vpc"
  }
}

#Subnets
resource "aws_subnet" "tf_subnets" {
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
  }
  vpc_id               = aws_vpc.tf_alb_vpc.id
  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "${var.project_name}_${each.value.name}"
  }
}

#Elastic ip
resource "aws_eip" "tf_alb_eip" {
  domain = "vpc"
}

#Internet Gateway
resource "aws_internet_gateway" "tf_alb_igw" {
  vpc_id = aws_vpc.tf_alb_vpc.id

  tags = {
    Name = "${var.project_name}_igw"
  }
}

#Nat Gateway
resource "aws_nat_gateway" "tf_alb_nat_gateway" {
  allocation_id = aws_eip.tf_alb_eip.id
  subnet_id     = data.aws_subnets.pubs.ids[0]

  tags = {
    Name = "${var.project_name}_nat_gateway"
  }
  depends_on = [aws_subnet.tf_subnets, aws_internet_gateway.tf_alb_igw]
}

#Public Routing Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.tf_alb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_alb_igw.id
  }

  tags = {
    Name = "${var.project_name}_pub_rt"
  }

  depends_on = [aws_internet_gateway.tf_alb_igw]
}

#Private Routing Table
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.tf_alb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_alb_nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}_pri_rt"
  }

  depends_on = [aws_nat_gateway.tf_alb_nat_gateway]
}
resource "aws_route_table_association" "pub_rt_ass" {
  for_each       = toset(data.aws_subnets.pubs.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.pub_rt.id
  depends_on     = [aws_internet_gateway.tf_alb_igw]
}
resource "aws_route_table_association" "pri_rt_ass" {
  for_each       = toset(data.aws_subnets.pris.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.pri_rt.id
  depends_on     = [aws_internet_gateway.tf_alb_igw]
}