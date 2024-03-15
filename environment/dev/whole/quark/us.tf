resource "aws_key_pair" "ssh_key_us" {
  public_key = file(var.public_key)
  provider   = aws.us_west_1
}

module "quark-servers-us" {
  source             = "../../../../modules/quark-server"
  quark_server_count = var.quark_server_count

  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_us]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_us

  ssh_key_name   = aws_key_pair.ssh_key_us.key_name
  aws_secrets    = var.aws_secrets
  startup_script = "../../../../scripts/startup.sh"

  providers = {
    aws = aws.us_west_1
  }
}

resource "aws_eip_association" "eip_assoc_quark_us" {
  count         = var.quark_server_count
  instance_id   = module.quark-servers-us.instance_id[count.index]
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.quark_us[count.index].allocation_id
  provider      = aws.us_west_1
}

module "grafana-prometheus-us" {
  source                 = "../../../../modules/aws-vm-linux"
  vm_name                = "tf-grafana-prometheus-us"
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_us]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_us
  aws_secrets            = var.aws_secrets
  ssh_key_name           = aws_key_pair.ssh_key_us.key_name
  provision_uri          = "s3://quark-deployment/prometheus-grafana.tar.gz"
  vm_size                = "t2.micro"
  private_ip             = "10.0.1.150"
  startup_script         = "../../../../scripts/startup.sh"
  providers = {
    aws = aws.us_west_1
  }
}

resource "aws_eip_association" "eip_assoc_grafana_us" {
  instance_id   = module.grafana-prometheus-us.instance_id
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.grafana_us.allocation_id
  provider      = aws.us_west_1
}
