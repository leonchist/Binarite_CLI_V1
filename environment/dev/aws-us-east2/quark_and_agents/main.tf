terraform {
  backend "local" {
    path = "../tf-states/quark.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../tf-states/network.tfstate"
  }
}


resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
}

module "quark-server" {
    source = "../../../../modules/aws-vm-linux"
    vm_name = format("quark-server-%d", 1+count.index)
    count = 2
    vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id ]
    subnet_id = data.terraform_remote_state.network.outputs.subnet_id
    aws_secrets = var.aws_secrets
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = format("10.0.1.%d", 100+count.index)
    startup_script = "../../../../scripts/startup.sh"
}

module "quark-agents" {
  source = "../../../../modules/aws-vm-linux"
  vm_name = "quark-agents"
  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id ]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  aws_secrets = var.aws_secrets
  ssh_key_name = aws_key_pair.ssh_key.key_name
  provision_uri = "s3://quark-deployment/quark-agents-deployment.tar.gz"
  vm_size = "t3.medium"
  private_ip = "10.0.1.200"
  startup_script = "../../../../scripts/startup.sh"
}

module "grafana-prometheus" {
  source = "../../../../modules/aws-vm-linux"
  vm_name = "grafana-prometheus"
  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.security_group_id ]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  aws_secrets = var.aws_secrets
  ssh_key_name = aws_key_pair.ssh_key.key_name
  provision_uri = "s3://quark-deployment/prometheus-grafana.tar.gz"
  vm_size = "t2.micro"
  private_ip = "10.0.1.150"
  startup_script = "../../../../scripts/startup.sh"
}