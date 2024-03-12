# Create a VPC
resource "aws_vpc" "vnet" {
  cidr_block = "10.0.0.0/16"

  tags = var.env.tags
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vnet.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vnet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.vnet.id
    tags = var.env.tags
}

resource "aws_security_group_rule" "inbound_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}


resource "aws_security_group_rule" "inbound_grafana" {
  type = "ingress"
  from_port = 3000
  to_port = 3000
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "inbound_prometheus" {
  type = "ingress"
  from_port = 9090
  to_port = 9090
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "inbound_quark" {
  type = "ingress"
  from_port = 5670
  to_port = 5670
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "inbound_quark_metrics" {
  type = "ingress"
  from_port = 9898
  to_port = 9898
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "inbound_rdp" {
  type = "ingress"
  from_port = 3389
  to_port = 3389
  protocol = "TCP"
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "outbound_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  security_group_id = aws_security_group.sg.id
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vnet.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}