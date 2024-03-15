output "instance_id" {
  description = "The ID of the VM"
  value       = module.quark-server.*.instance_id
}

output "vm_public_ips" {
  description = "Public ips of the VM"
  value       = module.quark-server.*.vm_public_ips

}

output "vm_private_ips" {
  description = "Private ips of the VM"
  value       = module.quark-server.*.vm_private_ips
}
