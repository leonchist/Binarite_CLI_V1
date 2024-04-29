resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename        = var.private_key_path
  content         = tls_private_key.rsa_private_key.private_key_openssh
  file_permission = "600"
}
