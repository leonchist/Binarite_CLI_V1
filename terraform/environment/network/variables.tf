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
      App = "Network"
      Project = "Quark"
      Role = "QuarkNetwork"
    }
  }
}
