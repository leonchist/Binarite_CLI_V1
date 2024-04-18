terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
}

provider "aws" {
  region = var.server_region
}

provider "random" {}

resource "random_uuid" "uuid" {
  count = 3
}