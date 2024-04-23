variable "server_region" {
  type    = string
  default = "eu-west-2"
}

variable "public_key" {
  type    = string
  default = "../../../../gdc-infra.pub"
}

variable "private_key" {
  type    = string
  default = "../../../../gdc-infra"
}

variable "env" {
  type = object({
    tags = object({
      Name    = string
      Source  = string
      Env     = string
      Owner   = string
      App     = string
      Project = string
      Role    = string
    })
  })

  default = {
    tags = {
      Name    = ""
      Source  = "terraform"
      Env     = "Dev"
      Owner   = "Simon"
      App     = "Quark server"
      Project = "Platform"
      Role    = "Cluster"
    }
  }
}

variable "vm_size" {
  description = "VM sizes, allowed values are s, m, l, xl"
  type        = string
  default     = "s"
}

variable "quark_private_ip" {
  type    = string
  default = "10.0.1.100"
}


variable "grafana_private_ip" {
  type    = string
  default = "10.0.1.150"
}

variable "bastion_private_ip" {
  type    = string
  default = "10.0.1.200"
}

variable "vm_module" {
  type    = string
  default = "../../../raw_modules/aws-vm-linux"
}

variable "services" {
  type    = list(string)
  default = ["quark_server", "grafana", "bastion"]
}

variable "quark_deployment_id" {
  type    = string
  default = "912334ee-bbaa-46dc-8f84-9cc01e4bab3b"
}

variable "user" {
  type    = string
  default = "ubuntu"
}

variable "ansible_inventory_path" {
  type = string
}

variable "known_host_path" {
  type = string
  default = "/etc/ansible/912334ee-bbaa-46dc-8f84-9cc01e4bab3b-known-host"
}