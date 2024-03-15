terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/elastic_ip.tfstate"
    region = "eu-central-1"
  }
}

module "eoc_bots_eu" {
  count = var.bots_instance_count_per_region
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = format("bots-eu-%0d",count.index)
  providers = {
    aws = aws.eu_central_1
  }
}

module "eoc_bots_us" {
  count = var.bots_instance_count_per_region
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = format("bots-us-%0d",count.index)
  providers = {
    aws = aws.us_west_1
  }
}

module "quark_eu" {
  count = var.quark_instance_count_per_region
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = format("quark-eu-%0d",count.index)
  providers = {
    aws = aws.eu_central_1
  }
}

module "quark_us" {
  count = var.quark_instance_count_per_region
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = format("quark-us-%0d",count.index)
  providers = {
    aws = aws.us_west_1
  }
}

module "grafana_eu" {
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = "grafana-eu"
  providers = {
    aws = aws.eu_central_1
  }
}

module "grafana_us" {
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = "grafana-us"
  providers = {
    aws = aws.us_west_1
  }
}

# module "agents_eu" {
#   source = "../../../../modules/aws-elasticip-with-domain"
#   domain = "mg-gdc.link"
#   subdomain = "agents-eu"
#   providers = {
#     aws = aws.eu_central_1
#   }
# }

module "agents_us" {
  source = "../../../../modules/aws-elasticip-with-domain"
  domain = "mg-gdc.link"
  subdomain = "agents-us"
  providers = {
    aws = aws.us_west_1
  }
}
