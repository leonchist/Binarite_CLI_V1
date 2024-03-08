module "network" {
    source = "../../../modules/aws-network"
}

resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
}

module "quark-server" {
    source = "../../../modules/aws-vm-linux"
    vm_name = format("quark-server-%d", 1+count.index)
    count = 2
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = format("10.0.1.%d", 100+count.index)
    startup_script = "../../../scripts/startup.sh"
}

module "quark-agents" {
  source = "../../../modules/aws-vm-linux"
  vm_name = "quark-agents"
  vpc_security_group_ids = [ module.network.security_group_id ]
  subnet_id = module.network.subnet_id
  aws_secrets = var.aws_secrets
  ssh_key_name = aws_key_pair.ssh_key.key_name
  provision_uri = "s3://quark-deployment/quark-agents-deployment.tar.gz"
  vm_size = "t3.medium"
  private_ip = "10.0.1.200"
  startup_script = "../../../scripts/startup.sh"
}

module "grafana-prometheus" {
  source = "../../../modules/aws-vm-linux"
  vm_name = "grafana-prometheus"
  vpc_security_group_ids = [ module.network.security_group_id ]
  subnet_id = module.network.subnet_id
  aws_secrets = var.aws_secrets
  ssh_key_name = aws_key_pair.ssh_key.key_name
  provision_uri = "s3://quark-deployment/prometheus-grafana.tar.gz"
  vm_size = "t2.micro"
  private_ip = "10.0.1.150"
  startup_script = "../../../scripts/startup.sh"
}

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

module "eoc-bots" {
  source = "../../../modules/aws-vm-windows"
  count = 10
  vm_name = format("eoc-bots-%02d", count.index)
  ssh_key_name = aws_key_pair.windows-key-pair.id
  vpc_security_group_ids = [ module.network.security_group_id ]
  subnet_id = module.network.subnet_id
  private_ip = format("10.0.1.%d", 50+count.index)
  vm_size = "c6i.4xlarge"
  vm_user_data = file("./user_data.txt")
  ami_name = "packer-windows-eoc*"
  ami_owner_alias = ["self"]
}