variable "bots_instance_count_per_region" {
  type    = number
  default = 5
}

variable "quark_instance_count_per_region" {
  type    = number
  default = 2
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
      App     = "Shared"
      Project = "Quark"
      Role    = "EIP"
    }
  }
}
