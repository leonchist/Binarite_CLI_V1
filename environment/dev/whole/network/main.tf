terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/network.tfstate"
    region = "eu-central-1"
  }
}
