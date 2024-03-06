output "vm_id" {
    description = "The ID of the VM"
    value = module.aws-vm-linux.vm_id
}

output "vm_public_ips" {
    description = "Public ips of the VM"
    value = module.aws-vm-linux.vm_public_ips
  
}

output "vm_private_ips" {
    description = "Private ips of the VM"
    value = module.aws-vm-linux.vm_private_ips
}