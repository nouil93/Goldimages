build {
  name = "vagrant"
  sources = ["source.qemu.rhel"]

  provisioner "ansible-local" {
    playbook_dir    = "provisioners/ansible"
    playbook_file   = "provisioners/ansible/vagrant.yml"
  }

  post-processor "manifest" {
    output     = "build/manifest-${var.name}.json"
    strip_path = true
  }

  post-processor "shell-local" {
    environment_vars = [
      "vm_name=${var.name}"
      ]
    script           = "scripts/post-processor-vagrant.sh"
  }
}

build {
  name = "nutanix"
  sources = ["source.qemu.rhel"]

  provisioner "ansible-local" {
    playbook_dir    = "provisioners/ansible"
    playbook_file   = "provisioners/ansible/nutanix.yml"
  }

  post-processor "shell-local" {
    environment_vars = [
      "IMAGE_NAME=${var.name}${var.version}", 
      "IMAGE_VERSION=${var.version}"
      ]
    script           = "scripts/post-processor-nutanix.sh"
  }
}

build {
  name = "libvirt"
  sources = ["source.qemu.rhel"]

  provisioner "ansible-local" {
    playbook_dir    = "provisioners/ansible"
    playbook_file   = "provisioners/ansible/libvirt.yml"
  }

  post-processor "manifest" {
    output     = "artifacts/manifest-libvirt.json"
    strip_path = true
  }

  post-processor "shell-local" {
    environment_vars = [
      "vm_name=${var.name}"
      ]
    script           = "scripts/post-processor-libvirt.sh"
  }
}