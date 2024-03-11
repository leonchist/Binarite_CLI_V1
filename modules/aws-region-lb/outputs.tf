output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.quark_nlb.dns_name
}

output "lb_zone_id" {
  description = "The ZONE ID name of the load balancer."
  value       = aws_lb.quark_nlb.zone_id
}
