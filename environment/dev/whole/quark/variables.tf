
variable "aws_secrets" {
  type = object({
    key_id     = string
    access_key = string
  })

  default = {
    "key_id" : "AKIAZRGHW6ZMDXGHIUPW",
    "access_key" : "2Mm2vm07wuvgwWqeMxxU7j7lPEn+9P9FVRuSKgNf"
  }
}

variable "quark_server_count" {
  description = "Replica count for quark servers"
  type        = number
  default     = 2
}

variable "public_key" {
  description = "Path to the public key to use"
  type        = string
  default     = "../../../../gdc-infra.pub"
}
