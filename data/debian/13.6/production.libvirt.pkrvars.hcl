# ==============================================================================
# Debian 13.6 - Production Libvirt
# ==============================================================================

name    = "debian-13.6-production-libvirt-uefi"
version = "13.6"

# Official Debian cloud image.
#
# Production should ultimately use a version-pinned image rather than
# "latest" so that a rebuild produces the same source image.
cloud_image_url = "https://cloud.debian.org/images/cloud/trixie/20260831-2587/debian-13-genericcloud-amd64-20260831-2587.qcow2"

# MUST be replaced by the checksum published by Debian before this image
# is considered production/reproducible.
cloud_image_checksum = "8ea9faae810043a0b35b0149f05014f26705c2339ffb11ead308f33e844a87cc3ef46ec81d5262b38817b6a88af404874d48a5857ebe072ef6a31dfb6e371f50"

ram       = 2048
cpu       = 2
disk_size = 102400

disk_interface = "virtio"

headless = true

ssh_username = "packer"