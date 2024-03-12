terraform {
  backend "local" {
    path = "../tf-states/lb.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../tf-states/network.tfstate"
  }
}

data "terraform_remote_state" "quark" {
  backend = "local"

  config = {
    path = "../tf-states/quark.tfstate"
  }
}

resource "aws_route53_zone" "main" {
  name              = "mg-gdc.link"
  delegation_set_id = "N00241192NTNWB5IFRQ3G"
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
    name                   = module.region-lb-us.lb_dns_name
    zone_id                = module.region-lb-us.lb_zone_id
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
    name                   = module.region-lb-eu.lb_dns_name
    zone_id                = module.region-lb-eu.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "latency_subdomain" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "latency.mg-gdc.link"
  type           = "A"
  set_identifier = "USWest1NLB"

  latency_routing_policy {
    region = "us-west-1"
  }

  alias {
    name                   = module.region-lb-us.lb_dns_name
    zone_id                = module.region-lb-us.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "latency_subdomain_eu" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "latency.mg-gdc.link"
  type           = "A"
  set_identifier = "EUCentral1NLB"

  latency_routing_policy {
    region = "eu-central-1"
  }

  alias {
    name                   = module.region-lb-eu.lb_dns_name
    zone_id                = module.region-lb-eu.lb_zone_id
    evaluate_target_health = true
  }
}
