terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/quark.tfstate"
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