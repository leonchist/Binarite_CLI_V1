output "quark_public_assigned_eip1" {
  value = aws_eip.us_west1_quark1.id
}

output "quark_public_assigned_eip2" {
  value = aws_eip.us_west1_quark2.id
}

output "quark_public_assigned_ip1" {
  value = aws_eip.us_west1_quark1.public_ip
}

output "quark_public_assigned_ip2" {
  value = aws_eip.us_west1_quark2.public_ip
}
