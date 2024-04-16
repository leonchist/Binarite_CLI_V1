
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

variable "quark_server_count" {
  description = "Replica count for quark servers"
  type        = number
  default     = 2
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
  default     = "../../../../gdc-infara.pub"
}

variable "instance_ip" {
  type        = string
  description = "The IP address of the instance to target for destruction."
}

variable "env" {
  type = object({
    tags = object({
      Source = string
      Env    = string
      Owner = string
      App = string
      Project = string
      Role = string
    })
  })

  default = {
    tags = {
      Source = "Terraform"
      Env = "Dev"
      Owner = "Hubert"
      App = "Quark"
      Project = "Quark"
      Role = "Server"
    }
  }
}
