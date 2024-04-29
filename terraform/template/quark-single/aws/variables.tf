variable "user" {
  type = string
  default = "metagravity"
}
variable "cloud_region" {
  type = string
}

variable "public_key" {
  type = string
  default = null
}

variable "private_key_path" {
  type = string
  default = null
}

variable "quark_vm_size" {
  type = string
  default = "l"
}

variable "ansible_inventory_path" {
  type = string
}

variable "environment" {
  description = "Path to the JSON file containing environment metadata"
  type        = string
}

variable "known_host_path" {
  type = string
}
