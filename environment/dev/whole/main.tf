resource "aws_eip" "us_west1_quark1" {
  domain = "vpc"

  provider = aws.us_west_1
}

resource "aws_eip" "us_west1_quark2" {
  domain = "vpc"

  provider = aws.us_west_1
}

module "us" {
  source = "./us"

  eip_us_west1_quark1 = aws_eip.us_west1_quark1.id
  eip_us_west1_quark2 = aws_eip.us_west1_quark2.id

  providers = {
    aws.us_west_1 = aws.us_west_1
  }
}
