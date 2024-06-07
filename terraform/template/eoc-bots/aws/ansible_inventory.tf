resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/./inventory.ini.tpl", {
    bots_ip         = module.eoc-bots.*.vm_public_ips
    bots_ssh_user   = "Administrator"
    bots_ssh_key    = local.private_key_path
    known_host      = var.known_host_path
    quark_ip        = var.quark_ip
    quark_port      = var.quark_port
  })
  filename = var.ansible_inventory_path
}