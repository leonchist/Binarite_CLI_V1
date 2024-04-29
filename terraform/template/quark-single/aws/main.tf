locals {
  metadata = jsondecode(file(var.environment))
}

locals {
  use_generated_keys         = var.private_key_path == null
  generated_private_key_path = "${var.deployment_folder}/id_rsa"
}

module "ssh_key" {
  count            = local.use_generated_keys ? 1 : 0
  source           = "../../../../terraform/raw_modules/ssh-key"
  private_key_path = local.generated_private_key_path
}


locals {
  public_key       = local.use_generated_keys ? module.ssh_key[0].public_key : var.public_key
  private_key_path = local.use_generated_keys ? local.generated_private_key_path : var.private_key_path
}

resource "aws_key_pair" "ssh_key" {
  public_key = local.public_key
  provider   = aws
  tags       = merge(local.metadata, { Name = "${local.metadata.Project}_QuarkSshKey_${local.metadata.Owner}" })
}

module "quark" {
  source = "../../../raw_modules/aws-vm-linux"

  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  vm_name                = "quark"
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = "10.0.1.100"
  vm_size                = var.quark_vm_size
  env                    = { tags = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}_QuarkServer_${local.metadata.Owner}", Source = "Terraform" }) }

  ssh_username = var.user

  providers = {
    aws = aws
  }
}

module "grafana_prometheus" {
  source                 = "../../../raw_modules/aws-vm-linux"
  vm_name                = "grafana-prometheus"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = "10.0.1.150"

  ssh_username = var.user

  env = { tags = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}_GrafanaServer_${local.metadata.Owner}", Source = "Terraform" }) }

  providers = {
    aws = aws
  }
}

module "bastion" {
  source                 = "../../../raw_modules/aws-vm-linux"
  vm_name                = "bastion"
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  ssh_key_name           = aws_key_pair.ssh_key.key_name
  private_ip             = "10.0.1.200"

  ssh_username = var.user

  env = { tags = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}_BastionServer_${local.metadata.Owner}", Source = "Terraform" }) }

  providers = {
    aws = aws
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../common/ansible/inventory.ini.tpl", {
    quark_ip     = module.quark.vm_private_ips[0]
    grafana_ip   = module.grafana_prometheus.vm_private_ips[0],
    bastion_ip   = aws_eip.elastic_ip[2].public_ip,
    ansible_user = var.user,
    private_key  = abspath(local.private_key_path)
    known_host   = var.known_host_path
  })
  filename = var.ansible_inventory_path
}
