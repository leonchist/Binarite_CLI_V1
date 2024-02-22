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
      username = string
      public_key = string
      size = string
      source_image = object({
        publisher = string
        offer = string
        sku = string
        version = string
      })
      startup_script = string
      provision_uri = string
    })

    default = {
      username = "adminuser"
      public_key =  "~/.ssh/id_rsa.pub"
      size = "Standard_DC16s_v3"
      source_image = {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts-gen2"
        version = "latest"
      }
      startup_script = "./startup.sh"
      provision_uri = "s3://quark-deployment/quark-deployment.tar.gz"
    }
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

    default = null
}