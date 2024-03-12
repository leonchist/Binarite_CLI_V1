variable "env" {
  type = object({
    tags = object({
      env = string
      source = string
    })
  })

  default = {
    tags = {
      env = "dev"
      source = "terraform"
    }
  }
}

variable "availability_zone" {
  type = string
  default = "us-east-2a"
}