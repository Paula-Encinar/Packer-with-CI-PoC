packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "ubuntu-focal" {
  ami_name      = "${var.ami_prefix}-focal-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}


build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu-focal"
  ]

  provisioner "shell" {
  environment_vars = [
    "FOO=hello world",
  ]
  inline = [
    "echo Installing Redis",
    "sleep 30",
    "sudo apt-get update",
  ]
 }
  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }

}





