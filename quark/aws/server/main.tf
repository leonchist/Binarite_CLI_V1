

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
  availability_zone = "us-east-2a"

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_network_interface" "nic" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["10.0.1.100"]

  tags = var.env.tags
}

data "aws_ami" "ubuntu2204" {
  most_recent = true

  filter {
    name   = "name"
    values = [ var.vm_configuration.source_image.name ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ var.vm_configuration.source_image.publisher ] # Canonical
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file(var.vm_configuration.public_key)
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu2204.id
  instance_type = var.vm_configuration.size

  key_name      = aws_key_pair.ssh_key.key_name

  user_data = templatefile(var.vm_configuration.startup_script, { AWS_ACCESS_KEY_ID=var.aws_secrets.key_id, AWS_SECRET_ACCESS_KEY=var.aws_secrets.access_key, PROVISION_URI=var.vm_configuration.provision_uri })
  user_data_replace_on_change = true

  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  associate_public_ip_address = true

  tags = var.env.tags
}

output "ec2_global_ips" {
  value = ["${aws_instance.vm.*.public_ip}"]
}