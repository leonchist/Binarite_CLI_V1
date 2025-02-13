variable "metadata" {
  type = object({
    Env     = string
    Role    = string
    Owner   = string
    Project = string
    Uuid    = string
  })
}

variable "basename" {
  default = "terraform-platform"
}

variable "owner" {
  default = "anonymous"
}

variable "vm_name" {
  description = ""
  type        = string
  default     = "gcp_vm"

}

variable "vm_size" {
  description = "VM size, allowed values are s, m, l, xl"
  type        = string
  default     = "s"
}

variable "startup_script" {
  type    = string
  default = null
}

variable "image_name" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "available_vm_size" {
  type = map(string)
  default = {
    s  = "c3d-standard-8"
    m  = "c3d-standard-16"
    l  = "c3d-standard-30"
    xl = "c3d-standard-60"
  }
}

variable "tags" {
  default = []
}

variable "service_account_email" {
}

variable "subnet_link" {
}

variable "with_public_ip" {
  type    = bool
  default = false
}

variable "ssh_username" {
  default = "metagravity"
}

variable "ssh_publickey" {
}

variable "zone" {
}
