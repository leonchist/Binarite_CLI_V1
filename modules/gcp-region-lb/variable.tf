variable "basename" {
  default = "terraform-platform"
}

variable "owner" {
  default = "anonymous"
}

variable "vpc_link" {
}

variable "port_healtcheck" {
  type = number
}

variable "port_listen" {
  type = number
}

variable "target_instances" {
  description = "selflinks of the instance to load balance"
}

variable "target_tags" {
  description = "tags used for the healthcheck and access firewall rule"
  type        = list(string)
}
