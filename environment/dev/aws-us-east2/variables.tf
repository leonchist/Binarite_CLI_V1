
variable "public_key" {
    description = "Path to the public key to use"
    type = string
    default = "../../../gdc-infra.pub"
#    default = "~/.ssh/id_rsa.pub"
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

#    default = null
  default = {"key_id":"AKIAZRGHW6ZMDXGHIUPW","access_key":"2Mm2vm07wuvgwWqeMxxU7j7lPEn+9P9FVRuSKgNf"}
}

variable "us_east2_quark1" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #1"
  type        = string
  default     = "3.23.31.147"
}

variable "us_east2_quark2" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #2"
  type        = string
  default     = "3.130.14.10"
}
