terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
      configuration_aliases = [ aws.us_west_1, aws.eu_east_2 ]
    }
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "us_west_1"
}

provider "aws" {
  region = "eu-east-2"
  alias  = "eu_east_2"
}
