variable "gcp_project" {
  default = "platform-419411"
}

variable "owner" {
}

variable "project" {
}

variable "user" {
  default = "metagravity"
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
}

variable "private_key" {
  description = "Path to the private key to use"
  type        = string
}

variable "subnet_local_ip_range" {
  default = "10.0.1.0/24"
}