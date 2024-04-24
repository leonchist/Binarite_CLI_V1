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
    quark: module.quark.vm_public_ips,
    grafana: module.grafana_prometheus.vm_public_ips,
    bastion: module.bastion.vm_public_ips,
  }
}

output "private_ips" {
  value = {
    quark: module.quark.vm_private_ips,
    grafana: module.grafana_prometheus.vm_private_ips,
    bastion: module.bastion.vm_private_ips,
  }
}