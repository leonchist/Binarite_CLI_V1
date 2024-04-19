terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
    backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "dev/single_quark.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.server_region
}

provider "random" {}

resource "random_uuid" "uuid" {
}