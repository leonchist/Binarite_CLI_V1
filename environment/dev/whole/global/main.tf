resource "aws_route53_zone" "main" {
  name = "mg-gdc.link"
}

resource "aws_route53_record" "geo_subdomain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "geo.mg-gdc.link"
  type    = "A"


  geolocation_routing_policy {
    continent = "NA"
  }

  set_identifier = "USWest1NLB"

  alias {
    name                   = var.nlb_us_dns
    zone_id                = var.nlb_us_zone
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "geo_subdomain_eu" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "geo.mg-gdc.link"
  type    = "A"

  set_identifier = "EUCentral1NLB"

  geolocation_routing_policy {
    continent = "EU"
  }

  alias {
    name                   = var.nlb_eu_dns
    zone_id                = var.nlb_eu_zone
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "latency_subdomain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "latency.mg-gdc.link"
  type    = "A"
  set_identifier = "USWest1NLB"

  latency_routing_policy {
    region = "us-west-1"
  }

  alias {
    name                   = var.nlb_us_dns
    zone_id                = var.nlb_us_zone
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "latency_subdomain_eu" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "latency.mg-gdc.link"
  type    = "A"
  set_identifier = "EUCentral1NLB"

  latency_routing_policy {
    region = "eu-central-1"
  }

  alias {
    name                   = var.nlb_eu_dns
    zone_id                = var.nlb_eu_zone
    evaluate_target_health = true
  }
}
