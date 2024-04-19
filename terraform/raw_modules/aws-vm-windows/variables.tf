variable "env" {
  type = object({
    tags = object({
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

variable "vm_name" {
  description = ""
  type        = string
  default     = "aws_vm"

}

variable "vm_size" {
  description = ""
  type        = string
  default     = "s"
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

variable "ami_id" {
  type = string
}

variable "vm_user_data" {
  type = string
}

variable "eip_allocation_id" {
  description = "The allocation ID of the Elastic IP to associate with the instance"
  type        = string
  default     = null
}
