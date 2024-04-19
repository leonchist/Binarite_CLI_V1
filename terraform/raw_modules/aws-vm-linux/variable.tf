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
  default     = "10.0.1.100"
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

variable "ami_owner_alias" {
  description = "Owner aliases of the image"
  type        = list(string)
  default     = ["amazon"]
}

variable "ami_name" {
  description = "ami name to match"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "startup_script" {
  type = string
}

variable "eip_allocation_id" {
  description = "The allocation ID of the Elastic IP to associate with the instance"
  type        = string
  default     = null
}


