
resource "aws_key_pair" "windows-key-pair-us" {
  key_name_prefix = "tf-windows-"
  public_key      = tls_private_key.rsa-windows-key.public_key_openssh
  provider        = aws.us_west_1
}

module "eoc-bots-us" {
  source                 = "../../../../modules/aws-vm-windows"
  count                  = 5
  vm_name                = format("tf-eoc-bots-%02d", count.index)
  ssh_key_name           = aws_key_pair.windows-key-pair-us.id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_us]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_us
  private_ip             = format("10.0.1.%d", 50 + count.index)
  vm_size                = "c6i.4xlarge"
  vm_user_data           = file("./user_data.txt")
  ami_id                 = aws_ami_copy.windows_ami-us.id

  providers = {
    aws = aws.us_west_1
  }
}
