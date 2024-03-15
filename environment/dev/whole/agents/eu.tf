# resource "aws_key_pair" "ssh_key_eu" {
#   public_key = file(var.public_key)
#   provider   = aws.eu_central_1
# }

# module "quark-agents-eu" {
#   source  = "../../../../modules/aws-vm-linux"
#   vm_name = "tf-agents-eu"

#   vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_id_eu]
#   subnet_id              = data.terraform_remote_state.network.outputs.subnet_id_eu

#   aws_secrets    = var.aws_secrets
#   ssh_key_name   = aws_key_pair.ssh_key_eu.key_name
#   provision_uri  = "s3://quark-deployment/quark-agents-deployment.tar.gz"
#   vm_size        = "t3.medium"
#   private_ip     = "10.0.1.200"
#   startup_script = "../../../../scripts/startup.sh"
#   providers = {
#     aws = aws.eu_central_1
#   }
# }

# resource "aws_eip_association" "eip_assoc_agents_eu" {
#   instance_id   = module.quark-agents-eu.instance_id
#   allocation_id = data.terraform_remote_state.elastic_ip.outputs.agents_eu.elastic_ip
#   provider      = aws.eu_central_1
# }