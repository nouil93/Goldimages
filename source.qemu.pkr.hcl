// ==============================================================================
//  Packer Template - GoldImages
// ==============================================================================
//
//  Author: Frédéric Delacour
//  Project: GoldImages (Infrastructure Image Automation)
//
//  Description:
//    Multi-target Packer build pipeline for:
//      - Vagrant (qcow2 / .box)
//      - Libvirt (qcow2)
//      - Nutanix AHV (qcow2 / raw)
//
//    Includes Ansible provisioning and post-processing workflows.
//
//  License:
//    MIT (or your choice)
//
// ==============================================================================

packer {
  required_plugins {
    qemu = {
      version = ">= 1.0"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}


source "qemu" "rhel" {
  vm_name           = var.name
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  output_directory  = "build/${var.name}"

  boot_command      = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    " text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/${var.config_file}",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  shutdown_command  = "echo 'packer' | sudo -S shutdown now"
  disk_cache        = "none"
  disk_compression  = true
  disk_discard      = "unmap"
  disk_interface    = var.disk_interface
  disk_size         = var.disk_size

  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  efi_firmware_vars = "/usr/share/OVMF/OVMF_VARS_4M.fd"
  efi_boot          = true

  boot_wait         = "10s"
  ssh_password      = var.ssh_password
  ssh_username      = var.ssh_username
  ssh_wait_timeout  = "30m"
  http_directory    = "."
  headless          = var.headless
  net_device        = "virtio-net"
  accelerator       = "kvm"
  format            = "qcow2"
  qemu_binary       = "/usr/bin/qemu-system-x86_64"
  qemuargs          = [
    ["-m", "${var.ram}M"],
    ["-smp", "${var.cpu}"], 
    ["-cpu", "host"],
    ["-serial", "mon:stdio"]
  ]
}

