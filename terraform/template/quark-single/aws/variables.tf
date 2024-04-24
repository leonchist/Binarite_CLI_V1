variable "user" {
  type = string
  default = "metagravity"
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
  default = "l"
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