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


variable "lb_name" {
  type = string
}

variable "lb_type" {
  type    = string
  default = "network"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "port_healtcheck" {
  type = number
}

variable "port_listen" {
  type = number
}

variable "target_ips" {
  type = list(string)
}
