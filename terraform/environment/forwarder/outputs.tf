output "us_forwarder_servers_ids" {
  value = [for instance in module.forwarder-server-us : instance.instance_id]
}

output "us_forwarder_nic" {
  value = flatten([for instance in module.forwarder-server-us : instance.secondary_nic_ids])
}
