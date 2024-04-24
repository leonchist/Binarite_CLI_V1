variable "user" {
  type = string
}

variable "server_region" {
  type = string
}

variable "public_key" {
  type = string
}

variable "private_key" {
  type = string
}

variable "quark_vm_size" {
  type = string
}

variable "ansible_inventory_path" {
  type = string
}

variable "metadata" {
  type = object({
    Env     = string
    Role    = string
    Owner   = string
    Project = string
    Uuid    = string
  })
}

variable "known_host_path" {
  type = string
}