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
      Source  = ""
      Env     = ""
      Owner   = ""
      App     = ""
      Project = ""
      Role    = ""
    }
  }
}


variable "availability_zone" {
  type    = string
  default = "us-east-2a"
}
