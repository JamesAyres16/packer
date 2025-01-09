
packer {
    required_plugins {
        qemu = {
            version = "~> 1"
            source  = "github.com/hashicorp/qemu"
        }
        vagrant = {
            version = ">= 1.1.1"
            source  = "github.com/hashicorp/vagrant"
        }
    }
}

variable "username" {
    type = string
}

variable "password" {
    type      = string
    sensitive = true
}

variable "hostname" {
    type    = string
    default = "ubuntu-server"
}


locals {
    output_directory = "builds"
}

source "qemu" "ubuntu" {
    vm_name          = "${var.hostname}.qcow2"
    output_directory = "${local.output_directory}"
    cpus             = 4
    memory           = 8192
    accelerator      = "kvm"
    disk_size        = "30G"
    disk_compression = true
    format           = "qcow2"

    iso_url      = "https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso"
    iso_checksum = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"

    http_content = {
        "/meta-data" = file("files/meta-data"),
        "/user-data" = templatefile("templates/user-data.pkrtpl.hcl", {
            hostname           = var.hostname
            username           = var.username
            encrypted_password = bcrypt(var.password)
            ssh_key            = file("files/id_rsa.pub")
        })
    }

    boot_command = [
        "<spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait><spacebar><wait>",
        "e<wait>",
        "<down><down><down><end>",
        " autoinstall ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" ",
        "<f10>"
    ]

    ssh_username     = var.username
    ssh_password     = var.password
    ssh_timeout      = "30m"
    shutdown_command = "sudo cloud-init clean --logs --machine-id --seed && sudo shutdown now"
}

build {
    sources = [ "source.qemu.ubuntu" ]

    post-processor "vagrant" {
        output              = "${local.output_directory}/${var.hostname}.box"
        keep_input_artifact = true
    }
}
