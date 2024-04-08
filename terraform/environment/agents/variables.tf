
variable "public_key" {
  description = "Path to the public key to use"
  type        = string
  default     = "../../../../gdc-infra.pub"
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
      App = "Agents"
      Project = "Quark"
      Role = "Server"
    }
  }
}
