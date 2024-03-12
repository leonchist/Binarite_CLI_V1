module "region-lb-us" {
  source = "../../../../modules/aws-region-lb"
  lb_name = "quark"
  subnet_ids = [ data.terraform_remote_state.network.outputs.subnet_id_us ]
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id_us
  port_healtcheck = 9898
  port_listen = 5670
  quark_instance_ids = data.terraform_remote_state.quark.outputs.us_quark_servers_ids

  providers = {
    aws = aws.us_west_1
  }
}