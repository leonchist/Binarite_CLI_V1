variable "lb_name" {
  type = string
}

variable "lb_type" {
  type = string
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
