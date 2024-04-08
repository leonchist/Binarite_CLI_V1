resource "aws_key_pair" "ssh_key_eu" {
  public_key = file(var.public_key)
  provider   = aws.eu_central_1
  tags = var.env.tags
}

module "quark-servers-eu" {
  source             = "../../raw_modules/quark-server"
  quark_server_count = var.quark_server_count

  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_eu]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_eu

  ssh_key_name   = aws_key_pair.ssh_key_eu.key_name
  aws_secrets    = var.aws_secrets
  startup_script = "../../../scripts/startup.sh"

  env = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

resource "aws_eip_association" "eip_assoc_quark_eu" {
  count         = var.quark_server_count
  instance_id   = module.quark-servers-eu.instance_id[count.index]
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.quark_eu[count.index].allocation_id
  provider      = aws.eu_central_1
}

module "grafana-prometheus-eu" {
  source                 = "../../raw_modules/aws-vm-linux"
  vm_name                = "tf-grafana-prometheus"
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_eu]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_eu
  aws_secrets            = var.aws_secrets
  ssh_key_name           = aws_key_pair.ssh_key_eu.key_name
  provision_uri          = "s3://quark-deployment/prometheus-grafana.tar.gz"
  vm_size                = "t2.micro"
  private_ip             = "10.0.1.150"
  startup_script         = "../../../scripts/startup.sh"

  env = var.env

  providers = {
    aws = aws.eu_central_1
  }
}

resource "aws_eip_association" "eip_assoc_grafana_eu" {
  instance_id   = module.grafana-prometheus-eu.instance_id
  allocation_id = data.terraform_remote_state.elastic_ip.outputs.grafana_eu.allocation_id
  provider      = aws.eu_central_1
}
