terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
      configuration_aliases = [ aws.us_west_1 ]
    }
  }
}
