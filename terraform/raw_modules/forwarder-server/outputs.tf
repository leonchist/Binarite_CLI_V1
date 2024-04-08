output "instance_id" {
  description = "The ID of the VM"
  value       = module.forwarder-server.*.instance_id
}

output "vm_public_ips" {
  description = "Public ips of the VM"
  value       = module.forwarder-server.*.vm_public_ips

}

output "vm_private_ips" {
  description = "Private ips of the VM"
  value       = module.forwarder-server.*.vm_private_ips
}

output "secondary_nic_ids" {
  description = "The IDs of the secondary network interfaces"
  value       = [for nic in aws_network_interface.secondary_nic : nic.id]
}
