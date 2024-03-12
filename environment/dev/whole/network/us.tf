module "network-us" {
  source = "../../../../modules/aws-network"

  availability_zone = "us-west-1b"
  providers = {
    aws = aws.us_west_1
  }
}