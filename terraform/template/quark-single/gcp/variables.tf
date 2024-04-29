variable "gcp_project" {
  default = "platform-419411"
}

variable "quark_vm_size" {
  default = "l"
}

variable "user" {
  default = "metagravity"
}

variable "public_key" {
  description = "Public key as a string"
  type        = string
  default = null
}

variable "private_key_path" {
  description = "Path to the private key to use"
  type        = string
  default = null
}

variable "subnet_local_ip_range" {
  default = "10.0.1.0/24"
}

variable "ansible_inventory_path" {
}

variable "known_host_path" {
}

variable "cloud_region" {
}

variable "environment" {
  description = "Path to the JSON file containing environment metadata"
  type        = string
}
