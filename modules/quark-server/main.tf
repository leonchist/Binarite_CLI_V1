module "quark-server" {
    source = "../aws-vm-linux"
    count = var.quark_server_count
    vm_name = format("tf-quark-server-%d", 1+count.index)
    vpc_security_group_ids = var.vpc_security_group_ids
    subnet_id = var.subnet_id
    aws_secrets = var.aws_secrets
    //eip_allocation_id = var.eip_allocation_ids[count.index]
    ssh_key_name = var.ssh_key_name
    private_ip = format("10.0.1.%d", 100+count.index)
    startup_script = var.startup_script
}
