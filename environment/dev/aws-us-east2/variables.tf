
variable "public_key" {
    description = "Path to the public key to use"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

    default = null
}