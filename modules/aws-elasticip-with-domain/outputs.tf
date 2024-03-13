output "elastic_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "hostname" {
  value = aws_route53_record.hostname.name
}