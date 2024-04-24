module "network-eu" {
  source = "../../raw_modules/aws-network"

  availability_zone = "eu-central-1b"
  env               = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

module "network-eu-backup" {
  source = "../../raw_modules/aws-network"

  availability_zone = "eu-central-1b"
  env               = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

