resource "aws_key_pair" "ssh_key_us" {
  public_key = file(var.public_key)
  provider   = aws.us_west_1
}

module "quark-agents-us" {
    count = 1
 source = "../../../../modules/aws-vm-linux"
 vm_name = "tf-agents-us"

  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id_us ]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id_us

 aws_secrets = var.aws_secrets
 ssh_key_name = aws_key_pair.ssh_key_us.key_name
 provision_uri = "s3://quark-deployment/quark-agents-deployment.tar.gz"
 vm_size = "t3.medium"
 private_ip = "10.0.1.200"
 startup_script = "../../../../scripts/startup.sh"

   providers = {
      aws = aws.us_west_1
  }
}
