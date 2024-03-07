module "network" {
    source = "../../../../modules/aws-network"

    availability_zone = "us-west-1b"
    providers = {
      aws = aws.us_west_1
    }
}

resource "aws_key_pair" "ssh_key" {
  public_key = file(var.public_key)
  provider   = aws.us_west_1
}

module "quark-server1" {
    source = "../../../../modules/aws-vm-linux"
    vm_name = "quark-server-1"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    eip_allocation_id = var.eip_us_west1_quark1
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = "10.0.1.100"
    startup_script = "../../../scripts/startup.sh"

    providers = {
      aws = aws.us_west_1
    }
}

module "quark-server2" {
    source = "../../../../modules/aws-vm-linux"
    vm_name = "quark-server-2"
    vpc_security_group_ids = [ module.network.security_group_id ]
    subnet_id = module.network.subnet_id
    aws_secrets = var.aws_secrets
    eip_allocation_id = var.eip_us_west1_quark2
    ssh_key_name = aws_key_pair.ssh_key.key_name
    private_ip = "10.0.1.101"
    startup_script = "../../../scripts/startup.sh"

    providers = {
      aws = aws.us_west_1
    }
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

resource "aws_lb" "quark_nlb" {
  name               = "quark-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [module.network.subnet_id] # Assuming the module.network returns subnet IDs
  enable_cross_zone_load_balancing = true

  provider = aws.us_west_1
}

resource "aws_lb_target_group" "quark_tg" {
  name     = "quark-tg"
  port     = 5670
  protocol = "TCP"
  vpc_id   = module.network.vpc_id

  provider = aws.us_west_1
}

resource "aws_lb_target_group_attachment" "quark1_tga" {
  target_group_arn = aws_lb_target_group.quark_tg.arn
  target_id        = module.quark-server1.instance_id
  port             = 5670

  provider = aws.us_west_1
}

resource "aws_lb_target_group_attachment" "quark2_tga" {
  target_group_arn = aws_lb_target_group.quark_tg.arn
  target_id        = module.quark-server2.instance_id
  port             = 5670

  provider = aws.us_west_1
}

resource "aws_lb_listener" "quark_listener" {
  load_balancer_arn = aws_lb.quark_nlb.arn
  protocol          = "TCP"
  port              = 9898
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quark_tg.arn
  }

  provider = aws.us_west_1
}

