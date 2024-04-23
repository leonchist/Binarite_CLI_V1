variable "server_region" {
  type    = string
  default = "eu-west-2"
}

variable "public_key" {
  type    = string
  default = "../../gdc-infra.pub"
}

variable "private_key" {
  type    = string
  default = "../../gdc-infra"
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
      Role    = "Quark Demo"
    }
  }
}

variable "aws_secrets" {
  type = object({
    key_id     = string
    access_key = string
  })

  default = {
    "key_id" : "AKIAZRGHW6ZMDXGHIUPW",
    "access_key" : "2Mm2vm07wuvgwWqeMxxU7j7lPEn+9P9FVRuSKgNf"
  }
}
variable "vm_size" {
  description = "VM sizs, allowed values are s, m, l, xl"
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

variable "services" {
  type    = list(string)
  default = ["quark_server", "grafana", "bastion"]
}

variable "quark_deployment_id" {
  type    = string
  default = "912334ee-bbaa-46dc-8f84-9cc01e4bab3b"
}

variable "user" {
  type = string
  default = "ubuntu"
}
