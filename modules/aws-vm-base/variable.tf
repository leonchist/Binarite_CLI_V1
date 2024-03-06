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

variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type = string 
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with."
  type = set(string)
}

variable "private_ip" {
  description = ""
  type = string
  default = "10.0.1.100"
}

variable "vm_ami" {
  description = ""
  type = string  
}

variable "vm_name" {
  description = ""
  type = string
  default = "aws_vm"
}

variable "vm_size" {
  description = ""
  type = string
  default = "t3.micro"
}

variable "provision_uri" {
  description = "AWS S3 URI to the docker-compose provisioning package"
  default = "s3://quark-deployment/quark-server-deployment.tar.gz"
}

variable "ssh_key_name" {
  description = "Name of the ssh key pair to use"
  type = string
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

    default = null
}

variable "vm_user_data" {
  type = string
}