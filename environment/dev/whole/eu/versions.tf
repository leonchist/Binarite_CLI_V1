terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [ aws.eu_east_2 ]
    }
  }
}

provider "aws" {
  region = "eu-east-2"
  alias  = "eu_east_2"
}
