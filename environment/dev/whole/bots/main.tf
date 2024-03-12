terraform {
  backend "local" {
    path = "../tf-states/bots.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../tf-states/network.tfstate"
  }
}

resource "tls_private_key" "rsa-windows-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "windows_key_file" {
  content  = tls_private_key.rsa-windows-key.private_key_pem
  filename = "windows-aws.pem"
}

data "aws_ami" "windows_ami-eu" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = [ "packer-windows-eoc*" ]
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