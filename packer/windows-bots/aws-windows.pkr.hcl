packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
 timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "windows" {
  ami_name      = "packer-windows-eoc-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t2.micro"
  //region        = "us-east-2"
  region = "eu-west-3"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon", "microsoft"]
  }

  user_data_file = "./bootstrap_win.txt"
  winrm_password = "YWgKXb9c6CGhCHoo"
  winrm_username = "Administrator"
}

build {
  name = "packer-windows"
  sources = [
    "source.amazon-ebs.windows"
  ]

  provisioner "powershell" {
    script = "./software_install.ps1"
  }

  provisioner "powershell" {
    inline = [
      // "& 'C:/Program Files/Amazon/EC2Launch/ec2launch' reset",
      "& 'C:/Program Files/Amazon/EC2Launch/ec2launch' sysprep --shutdown",
    ]
  }

}