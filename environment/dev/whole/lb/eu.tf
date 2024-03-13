module "region-lb-eu" {
  source             = "../../../../modules/aws-region-lb"
  lb_name            = "quark"
  subnet_ids         = [data.terraform_remote_state.network.outputs.subnet_id_eu]
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id_eu
  port_healtcheck    = 9898
  port_listen        = 5670
  target_ips = [ "10.0.1.100", "10.0.1.101" ] // Need to flatten eu_quark_servers_private_ips

  providers = {
    aws = aws.eu_central_1
  }
}