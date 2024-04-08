terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/agents.tfstate"
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

data "terraform_remote_state" "elastic_ip" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/elastic_ip.tfstate"
    region = "eu-central-1"
  }
}
