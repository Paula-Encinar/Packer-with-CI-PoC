packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "ubuntu-focal-west" {
  region = "us-west-2"
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "base_west" {
  ami_name      = "packer-aws-image"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = data.amazon-ami.ubuntu-focal-west.id
  ssh_username  = "ubuntu"
}

build {
  name = "packer-golden-image"
  sources = [
    "source.amazon-ebs.base_west"
  ]

  provisioner "shell" {
    inline = ["sudo apt-get update && sudo apt-get upgrade -y"]
  }
  provisioner "shell" {
    scripts = [
      "nodeinstallation.sh",
      "nvm.sh"
    
    ]
  }
  provisioner "shell" {
    inline = ["nvm install node"]
  }

  post-processor "manifest" {
    output = "packer_manifest.json"
  }
}