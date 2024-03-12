variable "quark_server_count" {
    description = "Replica count for quark servers"
    type        = number
    default     = 2
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with."
  type = set(string)
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  type = string
}

variable "eip_allocation_ids" {
  description = "The allocation ID of the Elastic IP to associate with the instance"
  type        = list(string)
  default = null
}

variable "aws_secrets" {
    type = object({
      key_id = string
      access_key = string
    })

    default = null
}

variable "ssh_key_name" {
    type = string
}

variable "startup_script" {
  type = string
  default = "../../scripts/startup.sh"
}