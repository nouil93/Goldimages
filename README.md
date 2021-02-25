# Gold Images



listes des dependances:
 - fuseiso
 - mkisofs
 - virt-syspreps retrouver le nom du paquet

# Installation Ubuntu 18.04 lts
  sudo apt install -y cowsay
  sudo apt install -y python3-venv
  sudo apt install -y cpu-checker
  sudo kvm-ok
  sudo apt update
  sudo apt install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager
  sudo usermod -aG kvm $$USER

# Usage
  make image distrib=ubuntu version=18.04

# Add new distribution version
  create the version folder and add data.jon within.# Goldimage
