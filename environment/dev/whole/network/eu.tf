module "network-eu" {
  source = "../../../../modules/aws-network"

  availability_zone = "eu-central-1b"
  providers = {
    aws = aws.eu_central_1
  }
}

