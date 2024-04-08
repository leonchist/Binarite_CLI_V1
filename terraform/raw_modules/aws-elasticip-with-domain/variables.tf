variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
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
      Source = ""
      Env = ""
      Owner = ""
      App = ""
      Project = ""
      Role = ""
    }
  }
}
