variable "metadata" {
  type = object({
    Env = string
    Role = string
    Owner = string
    Project = string
    Uuid = string
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
  description = "VM sizs, allowed values are s, m, l, xl"
  type        = string
  default     = "s"
}

variable "startup_script" {
  type = string
  default = null
}

variable "image_name" {
  default = "debian-cloud/debian-11"
}

variable "available_vm_size" {
  type = map(string)
  default = {
    s  = "f1-micro"
    m  = "c2-standard-4"
    l  = "c2-standard-16"
    xl = "c2-standard-60"
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
