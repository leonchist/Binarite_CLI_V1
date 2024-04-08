variable "instance_count_per_region" {
  type    = number
  default = 5
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
      App = "Bots"
      Project = "Quark"
      Role = "Server"
    }
  }
}
