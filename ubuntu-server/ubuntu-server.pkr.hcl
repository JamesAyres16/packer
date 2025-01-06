packer {
    required_plugins {
        qemu = {
            version = "~> 1"
            source  = "github.com/hashicorp/qemu"
        }
    }
}

locals {
    hostname = "ubuntu-server"
    username = "james"
}

variable "password" {
    type        = string
    description = "Default admin password"
    sensitive   = true
}

source "qemu" "ubuntu" {
    vm_name          = "${local.hostname}.qcow2"
    output_directory = "builds"
    cpus             = 2
    memory           = 4096
    accelerator      = "kvm"
    disk_size        = "30G"
    disk_compression = true
    format           = "qcow2"

    iso_url      = "https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso"
    iso_checksum = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"

    http_content   = {
        "/meta-data" = file("files/meta-data"),
        "/user-data" = templatefile("templates/user-data.pkrtpl.hcl", {
            hostname           = local.hostname
            username           = local.username
            encrypted_password = bcrypt(var.password)
            ssh_key            = file("~/.ssh/id_rsa.pub")
        })
    }

    boot_wait    = "2s"
    boot_command = [
        "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
        "e<wait>",
        "<down><down><down><end>",
        " autoinstall ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" ",
        "<f10>"
    ]

    ssh_username = local.username
    ssh_password = var.password
    ssh_timeout  = "30m"
    shutdown_command = "echo ${var.password} | sudo -S shutdown -P now"
}

build {
    name    = "iso"
    sources = [ "source.qemu.ubuntu" ]
    provisioner "shell" {
        inline = [
            "echo ${var.password} | sudo -S sh -c 'echo \"${local.username}  ALL = (ALL) NOPASSWD: ALL\" > /etc/sudoers.d/${local.username}'"
        ]
    }
}
