output "subnet_id" {
  description = ""
  value = aws_subnet.subnet.id
}

output "security_group_id" {
    description = ""
    value = aws_security_group.sg.id
}

output "vpc_id" {
  value = aws_vpc.vnet.id
  description = "The ID of the VPC created"
}
