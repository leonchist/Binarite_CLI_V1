output "vm_id" {
    description = "The ID of the VM"
    value = aws_instance.vm.id
}

output "vm_public_ips" {
    description = "Public ips of the VM"
    value = ["${aws_instance.vm.*.public_ip}"]

}

output "vm_private_ips" {
    description = "Private ips of the VM"
    value = ["${aws_instance.vm.*.private_ip}"]
}

output "password_data" {
    value = aws_instance.vm.password_data
}
