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

resource "aws_key_pair" "windows-key-pair" {
  key_name_prefix = "tf-windows-"
  public_key      = tls_private_key.rsa-windows-key.public_key_openssh
}

resource "local_file" "windows_key_file" {
  content  = tls_private_key.rsa-windows-key.private_key_pem
  filename = "windows-aws.pem"
}

module "eoc-bots" {
  source = "../../../../modules/aws-vm-windows"
  count = 5
  vm_name = format("eoc-bots-%02d", count.index)
  ssh_key_name = aws_key_pair.windows-key-pair.id
  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id ]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  private_ip = format("10.0.1.%d", 50+count.index)
  vm_size = "c6i.4xlarge"
  vm_user_data = file("./user_data.txt")
  ami_name = "packer-windows-eoc*"
  ami_owner_alias = ["self"]
}