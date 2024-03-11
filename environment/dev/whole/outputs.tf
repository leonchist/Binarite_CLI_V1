output "us_quark_public_assigned_ip1" {
  value = aws_eip.us_west1_quark1.public_ip
}

output "us_quark_public_assigned_ip2" {
  value = aws_eip.us_west1_quark2.public_ip
}

output "us_quark_lb" {
  description = "The DNS name of the US regional load balancer."
  value = module.us.quark_nlb_dns_name
}

output "eu_quark_public_assigned_ip1" {
  value = aws_eip.eu_central1_quark1.public_ip
}

output "eu_quark_public_assigned_ip2" {
  value = aws_eip.eu_central1_quark2.public_ip
}

output "eu_quark_lb" {
  description = "The DNS name of the EU regional load balancer."
  value = module.eu.quark_nlb_dns_name
}

output "global_lb_geo" {
  description = "Global GEO-LB"
  value = module.global.global_lb_geo
}

output "global_lb_latency" {
  description = "Global Latency-LB"
  value = module.global.global_lb_latency
}
