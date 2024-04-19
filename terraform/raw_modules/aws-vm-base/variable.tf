variable "env" {
  type = object({
    tags = object({
      Name = string
      Source = string
      Env    = string
      Owner = string
      App = string
      Project = string
      Role = string
    })
  })

  default = {
    tags = {
      Name = ""
      Source = ""
      Env = ""
      Owner = ""
      App = ""
      Project = ""
      Role = ""
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
    s  = "t3.micro"
    m  = "c5.large"
    l  = "c5.4xlarge"
    xl = "c5.12xlarge"
  }
}

variable "vm_size" {
  description = "VM sizs, allowed values are s, m, l, xl"
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
  type = string
}

variable "vm_disk_size" {
  type    = number
  default = 30
}

variable "vm_get_password" {
  type    = bool
  default = false
}
