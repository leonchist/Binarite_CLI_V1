
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

variable "forwarder_server_count" {
  description = "Replica count for forwarder servers"
  type        = number
  default     = 1
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
  default     = "../../../../gdc-infra.pub"
}

variable "env" {
  type = object({
    tags = object({
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
      Source  = "Terraform"
      Env     = "Dev"
      Owner   = "Hubert"
      App     = "Forwarder"
      Project = "Quark"
      Role    = "Server"
    }
  }
}
