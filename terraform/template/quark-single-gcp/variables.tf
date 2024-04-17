variable "gcp_project" {
  default = "platform-419411"
}

variable "owner" {
}

variable "project" {
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
}

variable "private_key" {
  description = "Path to the private key to use"
  type        = string
}