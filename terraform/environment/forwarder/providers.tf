terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version                = "5.38.0"
      configuration_aliases = [aws.us_west_1, aws.eu_central_1]
    }
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "us_west_1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eu_central_1"
}
