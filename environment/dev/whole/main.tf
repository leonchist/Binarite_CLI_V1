resource "aws_eip" "us_west1_quark1" {
  domain = "vpc"
  provider = aws.us_west_1
}

resource "aws_eip" "us_west1_quark2" {
  domain = "vpc"
  provider = aws.us_west_1
}

resource "aws_eip" "eu_central1_quark1" {
  domain = "vpc"
  provider = aws.eu_central_1
}

resource "aws_eip" "eu_central1_quark2" {
  domain = "vpc"
  provider = aws.eu_central_1
}

module "us" {
  source = "./us"

  eip_us_west1_quark1 = aws_eip.us_west1_quark1.id
  eip_us_west1_quark2 = aws_eip.us_west1_quark2.id
}

module "eu" {
  source = "./eu"

  eip_eu_central1_quark1 = aws_eip.eu_central1_quark1.id
  eip_eu_central1_quark2 = aws_eip.eu_central1_quark2.id
}

module "global" {
  source = "./global"

  nlb_us_dns = module.us.quark_nlb_dns_name
  nlb_us_zone = module.us.quark_nlb_zone_id

  nlb_eu_dns = module.eu.quark_nlb_dns_name
  nlb_eu_zone = module.eu.quark_nlb_zone_id
}
