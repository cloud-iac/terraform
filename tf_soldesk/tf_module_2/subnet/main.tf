// Create a Subnet
resource "aws_subnet" "subnets" {
  for_each          = merge(var.subnets.pub_subnets, var.subnets.pri_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.pjt_name}_${each.key}_sn"
  }
}

// Create a Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.pjt_name}_pub_rt"
  }
}

// Associate a Public Route Table With a Public Subnet
resource "aws_route_table_association" "pub_rt_ass" {
  for_each       = var.subnets.pub_subnets
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.pub_rt.id
}

// Create a Private Route Table
resource "aws_route_table" "pri_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.pjt_name}_pri_rt"
  }
}

// Associate a Public Route Table With a Public Subnet
resource "aws_route_table_association" "pri_rt_ass" {
  for_each       = var.subnets.pri_subnets
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.pri_rt.id
}