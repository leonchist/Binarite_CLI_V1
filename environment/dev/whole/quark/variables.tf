
variable "aws_secrets" {
  type = object({
    key_id     = string
    access_key = string
  })

  #    default = null
  default = { "key_id" : "AKIAZRGHW6ZMDXGHIUPW", "access_key" : "2Mm2vm07wuvgwWqeMxxU7j7lPEn+9P9FVRuSKgNf" }
}

variable "eip_eu_central1_quark1" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #1 - eipalloc-0c83b21e1198338a6"
  type        = string
  default     = "18.198.79.56"
}

variable "eip_eu_central1_quark2" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #2 - eipalloc-0a9b2a63960606400"
  type        = string
  default     = "3.125.97.100"
}


variable "eip_us_west1_quark1" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #1 - eipalloc-019f4b7d29d49987d"
  type        = string
  default     = "52.8.123.0"
}

variable "eip_us_west1_quark2" {
  description = "The Elastic IP address to associate with the EC2 instance Quark #2 - eipalloc-0bc33436e3a2c4718"
  type        = string
  default     = "52.8.215.250"
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