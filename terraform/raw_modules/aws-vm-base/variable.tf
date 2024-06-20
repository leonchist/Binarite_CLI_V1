variable "env" {
  type = object({
    tags = object({
      Name    = string
      Source  = string
      Env     = string
      Owner   = string
      Project = string
      Role    = string
      Uuid    = string
    })
  })

  default = {
    tags = {
      Name    = ""
      Source  = ""
      Env     = ""
      Owner   = ""
      Project = ""
      Role    = ""
      Uuid    = ""
    }
  }
}


variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with."
  type        = set(string)
}

variable "private_ip" {
  description = ""
  type        = string
  default     = null
}

variable "vm_ami" {
  description = ""
  type        = string
}

variable "vm_name" {
  description = ""
  type        = string
  default     = "aws_vm"
}

variable "available_vm_size" {
  type = map(string)
  default = {
    s  = "m7i.2xlarge"
    m  = "m7i.4xlarge"
    l  = "m7i.8xlarge"
    xl = "m7i.16xlarge"
  }
}

variable "vm_size" {
  description = "VM sizes, allowed values are s, m, l, xl"
  type        = string
  default     = "s"
}

variable "provision_uri" {
  description = "AWS S3 URI to the docker-compose provisioning package"
  default     = "s3://quark-deployment/quark-server-deployment.tar.gz"
}

variable "ssh_key_name" {
  description = "Name of the ssh key pair to use"
  type        = string
}

variable "aws_secrets" {
  type = object({
    key_id     = string
    access_key = string
  })

  default = null
}
variable "vm_user_data" {
  type    = string
  default = null
}

variable "vm_disk_size" {
  type    = number
  default = 30
}

variable "vm_get_password" {
  type    = bool
  default = false
}
