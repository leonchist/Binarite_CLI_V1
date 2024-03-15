terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/ami_copy.tfstate"
    region = "eu-central-1"
  }
}

data "aws_ami" "windows_ami-eu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["packer-windows-eoc*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  provider = aws.eu_central_1
}

resource "aws_ami_copy" "windows_ami-us" {
  name              = data.aws_ami.windows_ami-eu.name
  source_ami_id     = data.aws_ami.windows_ami-eu.id
  source_ami_region = "eu-central-1"

  provider = aws.us_west_1
}