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

source "amazon-ebs" "ubuntu" {
  ami_name = "my_first_ami_${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.my_region}"
  source_ami_filter {
    filters = {
      name                = "${var.source_ami_name}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["374168611083"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}

variable "my_region" {
  type = string
  default = "us-west-1"
}

variable "source_ami_name" {
  type = string
  default = "us-west-1 image for Ubuntu_22.04"
}


