
resource "aws_key_pair" "windows-key-pair-eu" {
  key_name_prefix = "tf-windows-"
  public_key      = tls_private_key.rsa-windows-key.public_key_openssh
  provider        = aws.eu_central_1

  tags = var.env.tags
}

module "eoc-bots-eu" {
  source                 = "../../raw_modules/aws-vm-windows"
  count                  = var.instance_count_per_region
  vm_name                = format("tf-eoc-bots-%02d", count.index)
  ssh_key_name           = aws_key_pair.windows-key-pair-eu.id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_eu]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_eu
  private_ip             = format("10.0.1.%d", 50 + count.index)
  vm_size                = "c6i.4xlarge"
  vm_user_data           = file("./user_data.txt")
  ami_id = data.aws_ami.windows_ami-eu.id

  env = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

resource "aws_eip_association" "eip_assoc_bots_eu" {
  count         = var.instance_count_per_region
  instance_id   = module.eoc-bots-eu[count.index].instance_id
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.bots_eu[count.index].allocation_id
  provider      = aws.eu_central_1
}
