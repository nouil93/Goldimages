source "qemu" "rhel" {
  iso_url            = "http://mirror.example.com/isos/rhel9.iso"
  iso_checksum       = "sha256:..."
  output_directory   = "output/rhel"
  vm_name            = "rhel9"
  disk_size          = var.disk_size
  format             = "qcow2"
  accelerator        = "kvm"
  memory             = var.vm_memory
  cpus               = var.vm_cpus
  http_directory     = "http"

  boot_command = [
    "<tab> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/rhel9-xfs.ks <enter>"
  ]

  communicator       = "ssh"
  ssh_username       = "root"
  ssh_password       = "redhat"
  shutdown_command   = "shutdown now"
}
