terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/network.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_route53_zone" "main" {
  name              = "mg-gdc.link"
  delegation_set_id = "N00241192NTNWB5IFRQ3G"
}
