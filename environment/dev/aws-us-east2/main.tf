module "network" {
    source = "../../../modules/aws-network"
}

resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
}

resource "aws_eip" "us_east2_quark1" {
  domain = "vpc"
}
resource "aws_eip" "us_east2_quark2" {
  domain = "vpc"
}

module "quark-server1" {
    source = "../../../modules/aws-vm-linux"
    vm_name = "gdc-quark-server-1"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    eip_allocation_id = aws_eip.us_east2_quark1.id
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = "10.0.1.100"
    startup_script = "../../../scripts/startup.sh"
}

module "quark-server2" {
    source = "../../../modules/aws-vm-linux"
    vm_name = "gdc-quark-server-2"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    eip_allocation_id = aws_eip.us_east2_quark2.id
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = "10.0.1.101"
    startup_script = "../../../scripts/startup.sh"
}

#module "quark-agents" {
#  source = "../../../modules/aws-vm-linux"
#  vm_name = "quark-agents"
#  vpc_security_group_ids = [ module.network.security_group_id ]
#  subnet_id = module.network.subnet_id
#  aws_secrets = var.aws_secrets
#  ssh_key_name = aws_key_pair.ssh_key.key_name
#  provision_uri = "s3://quark-deployment/quark-agents-deployment.tar.gz"
#  vm_size = "t3.medium"
#  private_ip = "10.0.1.200"
#  startup_script = "../../../scripts/startup.sh"
#}

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

#module "eoc-bots" {
#  source = "../../../modules/aws-vm-windows"
#  vm_name = "eoc-bots"
#  ssh_key_name = aws_key_pair.windows-key-pair.id
#  startup_script = null
#  vpc_security_group_ids = [ module.network.security_group_id ]
#  subnet_id = module.network.subnet_id
#  private_ip = "10.0.1.50"
#  vm_size = "c7i.4xlarge"
#}
