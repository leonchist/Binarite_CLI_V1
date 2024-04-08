module "network-us" {
  source = "../../raw_modules/aws-network"

  availability_zone = "us-west-1b"
  env = var.env

  providers = {
    aws = aws.us_west_1
  }
}

module "network-us-backup" {
  source = "../../raw_modules/aws-network"

  availability_zone = "us-west-1b"
  env = var.env

  providers = {
    aws = aws.us_west_1
  }
}
