# ==============================================================================
# Debian 13.6 - Standard Libvirt
# ==============================================================================

name    = "debian-13.6-standard-libvirt-uefi"
version = "13.6"

# Official Debian cloud image.
#
# Prefer a version-pinned image for reproducible production builds.
# Replace the URL/checksum below with the exact Debian cloud image selected
# for the 13.6 build.
cloud_image_url = "https://cloud.debian.org/images/cloud/trixie/20260831-2587/debian-13-genericcloud-amd64-20260831-2587.qcow2"

# Do not use "none" in CI/production.
# Pin this to the SHA512/SHA256 published by Debian.
cloud_image_checksum = "8ea9faae810043a0b35b0149f05014f26705c2339ffb11ead308f33e844a87cc3ef46ec81d5262b38817b6a88af404874d48a5857ebe072ef6a31dfb6e371f50"

ram       = 2048
cpu       = 2
disk_size = 32768

disk_interface = "virtio"

headless = false

ssh_username = "packer"