output "global_lb_geo" {
    description = "Global GEO-LB"
    value = aws_route53_record.geo_subdomain.name
}

output "global_lb_latency" {
  description = "Global Latency-LB"
  value = aws_route53_record.latency_subdomain.name
}
