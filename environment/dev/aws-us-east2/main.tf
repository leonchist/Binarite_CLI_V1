module "network" {
    source = "../../../modules/aws-network"
}

resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
}

module "quark-server" {
    source = "../../../modules/aws-vm"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    ssh_key_name = aws_key_pair.ssh_key.key_name
}

module "quark-agents" {
  source = "../../../modules/aws-vm"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    ssh_key_name = aws_key_pair.ssh_key.key_name
    provision_uri = "s3://quark-deployment/quark-agents-deployment.tar.gz"
    vm_size = "t3.medium"
}