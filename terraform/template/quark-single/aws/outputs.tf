output "outputs" {
  value = {
    network : {
      vpc_id : module.aws_net.vpc_id,
      subnet_id : module.aws_net.subnet_id,
      security_group_id : module.aws_net.security_group_id
    },
    quark : {
      instance_id : module.quark.instance_id,
    },
    bastion : {
      instance_id : module.bastion.instance_id,
    },
    grafana : {
      instance_id : module.grafana_prometheus.instance_id,
    }
  }
}

output "public_ips" {
  value = {
    quark : aws_eip.elastic_ip[0].public_ip,
    grafana : aws_eip.elastic_ip[1].public_ip,
    bastion : aws_eip.elastic_ip[2].public_ip,
  }
}

output "private_ips" {
  value = {
    quark : module.quark.vm_private_ips,
    grafana : module.grafana_prometheus.vm_private_ips,
    bastion : module.bastion.vm_private_ips,
  }
}