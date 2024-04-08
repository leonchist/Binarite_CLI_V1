terraform {
  backend "s3" {
    bucket = "gdc-terraform-infra"
    key    = "prod/bots.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/network.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "elastic_ip" {
  backend = "s3"
  config = {
    bucket = "gdc-terraform-infra"
    key    = "prod/elastic_ip.tfstate"
    region = "eu-central-1"
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

data "aws_ami" "windows_ami-us" {
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
  provider = aws.us_west_1
}
