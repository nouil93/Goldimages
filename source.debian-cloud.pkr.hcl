source "qemu" "debian_cloud" {
  vm_name = "${var.name}.qcow2"

  iso_url      = var.cloud_image_url
  iso_checksum = var.cloud_image_checksum

  disk_image = true
  format     = "qcow2"

  output_directory = "build/${var.name}"

  disk_size        = var.disk_size
  disk_interface   = "virtio"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"

  accelerator = "kvm"
  headless    = var.headless

  net_device = "virtio-net"

  efi_boot          = true
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  efi_firmware_vars = "/usr/share/OVMF/OVMF_VARS_4M.fd"

  ssh_username         = "packer"
  ssh_private_key_file = var.ssh_private_key_file
  ssh_wait_timeout     = "10m"

  cd_label = "cidata"

  cd_content = {
    "meta-data" = templatefile(
      "${path.root}/templates/cloud-init/meta-data.pkrtpl.hcl",
      {
        hostname = var.name
      }
    )

    "user-data" = templatefile(
      "${path.root}/templates/cloud-init/debian-build-user-data.pkrtpl.hcl",
      {
        ssh_public_key = file(var.ssh_public_key_file)
      }
    )
  }

  shutdown_command = "sudo shutdown -P now"

  qemuargs = [
    ["-m", "${var.ram}M"],
    ["-smp", "${var.cpu}"],
    ["-cpu", "host"],
    ["-serial", "mon:stdio"]
  ]
}