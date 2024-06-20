resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/./inventory.ini.tpl", {
    agents_ip         = module.eoc-agents.*.vm_public_ips
    agents_ssh_user   = "Administrator"
    agents_ssh_key    = local.private_key_path
    known_host      = var.known_host_path
    quark_ip        = var.quark_ip
    quark_port      = var.quark_port
  })
  filename = var.ansible_inventory_path
}