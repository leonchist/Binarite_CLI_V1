output "allocation_id" {
  value = aws_eip.elastic_ip.allocation_id
}

output "public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "hostname" {
  value = aws_route53_record.hostname.name
}