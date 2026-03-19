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

variable "iso_url" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9-latest-x86_64-boot.iso"
}

variable "iso_checksum" {
  type    = string
  default = "0fad8d8b19a94a0222ea37152cdf5601229fe0178b651dc476e1cba41d2e6067"
}

variable "headless" {
  type    = bool
  default = true
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "cpu" {
  type    = string
  default = "2"
}

variable "name" {
  type    = string
  default = "none"
}

variable "ssh_password" {
  type    = string
  default = "vagrant"
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "9"
}

variable "disk_size" {
  type    = string
  default = "32768"
}

variable "disk_interface" {
  type = string
  default = "virtio"
}

variable "config_file" {
  type    = string
  default = ""
}
