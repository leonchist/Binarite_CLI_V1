locals {
  metadata = jsondecode(file(var.environment))
}

locals {
  generated_private_key_path = "${var.deployment_folder}/id_rsa"
}

module "ssh_key" {
  source           = "../../../../terraform/raw_modules/ssh-key"
  private_key_path = local.generated_private_key_path
}


locals {
  public_key       = module.ssh_key.public_key
  private_key_path = local.generated_private_key_path
}

data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon", "microsoft"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
  public_key = local.public_key
  tags       = merge(local.metadata, { Name = "${local.metadata.Project}_EoCBotsSshKey_${local.metadata.Owner}" })
}

module "eoc-bots" {
  source                 = "../../../raw_modules/aws-vm-windows"
  count                  = var.instance_count
  vm_name                = format("${local.metadata.Project}_${local.metadata.Role}_PlaytestBots%02d_${local.metadata.Owner}", count.index)
  ssh_key_name           = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [module.aws_net.security_group_id]
  subnet_id              = module.aws_net.subnet_id
  private_ip             = format("10.0.1.%d", 50 + count.index)
  vm_size                = "c6i.4xlarge"
  vm_user_data = templatefile("./user_data.tftpl", {
    windows_password = "6ThPzxsJm3v*&Jqk"
    ssh_public_key   = local.public_key
  })

  ami_id = data.aws_ami.windows_ami.id

  env = { tags = merge(local.metadata, { Source = "Platform", App = "Bots", Name = format("${local.metadata.Project}_${local.metadata.Role}_PlaytestBots%02d_${local.metadata.Owner}", count.index) }, ) }
}

# resource "aws_eip" "elastic_ip" {
#   count  = var.instance_count
#   domain = "vpc"
#   tags   = merge(local.metadata, { Name = "${local.metadata.Project}_${local.metadata.Role}Bots_ElasticIP_${local.metadata.Owner}" })
# }

# resource "aws_eip_association" "eip_assoc_bots" {
#   count = var.instance_count
#   instance_id   = module.eoc-bots[count.index].instance_id
#   allocation_id = aws_eip.elastic_ip[count.index].allocation_id
# }

# resource "local_file" "rdp"{
#   count = var.instance_count
#   content = templatefile("./rdp.tftpl", {
#     ip = module.eoc-bots[count.index].vm_public_ips[0]
#     username = "eoc"
#   })
#   filename = "${path.module}/eoc_bots_${count.index}.rdp"
# }

# To debug the user_data file generation
# resource "local_file" "foo" {
#   count = var.instance_count
#   content = templatefile("./user_data.tftpl", {
#     config           = local.eoc_bots_config[count.index]
#     windows_password = var.windows_password
#     eoc_url          = var.eoc_url
#     scripts_url      = var.scripts_url
#   })
#   filename = "${path.module}/user_data_${count.index}.txt"
# }
