output "public_key" {
  value = tls_private_key.rsa_private_key.public_key_openssh
}
