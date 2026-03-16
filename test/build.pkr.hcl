build {
  name = "vagrant-box"
  sources = ["source.qemu.rhel"]

  provisioner "shell" {
    script = "scripts/postinstall.sh"
  }

  post-processor "vagrant" {
    output = "images/rhel9.box"
    keep_input_artifact = true
  }
}

build {
  name = "nutanix-image"
  sources = ["source.qemu.rhel"]

  provisioner "shell" {
    script = "scripts/postinstall.sh"
  }

  post-processor "compress" {
    output = "images/rhel9.qcow2.gz"
    compression_level = 6
  }

  post-processor "checksum" {
    output = "images/rhel9.sha256"
    checksum_types = ["sha256"]
  }
}
