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

variable "vm_configuration" {
    type = object({
      public_key = string
      size = string
      source_image = object({
        publisher = string
        name = string
      })
      startup_script = string
      provision_uri = string
    })

    default = {
      public_key =  "~/.ssh/id_rsa.pub"
      size = "t3.micro"
      source_image = {
        publisher = "099720109477" // "Canonical"
        name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      }
      startup_script = "./startup.sh"
      provision_uri = "s3://quark-deployment/quark-server-deployment.tar.gz"
    }
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

    default = null
}