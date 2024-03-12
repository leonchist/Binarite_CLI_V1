
resource "aws_key_pair" "windows-key-pair-eu" {
  key_name_prefix = "tf-windows-"
  public_key      = tls_private_key.rsa-windows-key.public_key_openssh
  provider = aws.eu_central_1
}



module "eoc-bots-eu" {
  source = "../../../../modules/aws-vm-windows"
  count = 5
  vm_name = format("tf-eoc-bots-%02d", count.index)
  ssh_key_name = aws_key_pair.windows-key-pair-eu.id
  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id_eu ]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id_eu
  private_ip = format("10.0.1.%d", 50+count.index)
  vm_size = "c6i.4xlarge"
  vm_user_data = file("./user_data.txt")
  
  ami_id = data.aws_ami.windows_ami-eu.id

  providers = {
    aws = aws.eu_central_1
  }
}