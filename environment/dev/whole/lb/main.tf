terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/lb.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/network.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "quark" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/quark.tfstate"
    region = "eu-central-1"
  }
}

data "aws_route53_zone" "main" {
  name              = "mg-gdc.link"
}

resource "aws_route53_record" "geo_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
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
  zone_id = data.aws_route53_zone.main.zone_id
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
  zone_id        = data.aws_route53_zone.main.zone_id
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
  zone_id        = data.aws_route53_zone.main.zone_id
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
