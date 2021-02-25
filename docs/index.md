# Goldimages
Goldimages is a workaround  [**packer**](https://www.packer.io), to obtain all the Linux OS support by
opennebula and Libvirt Vagrant Image. This project provide automaticely some dependancies,
however you need to follow [Setup and Dependancies](#Setup and Dependancies) to obtain a valid environment to build your VM Images.
## Getting Started
### Setup and Dependancies
#### On Debian family
```bash
sudo apt install -y python3-venv cpu-checker cowsay shellcheck vagrant
sudo kvm-ok
sudo apt update
sudo apt install qemu qemu-kvm libvirt-bin bridge-utils virt-manager
sudo usermod -aG kvm $USER
```
## Commands
* `make` - Print Usage.
* `make image/opennebula distrib=centos version=8.2` - Build Opennebula Qcow2.

Distribution | version | commentary
------------ | ------------- | ------------
Centos | 8.1  | Opennebula Context version default 5.10.4, tests OK
Centos | 8.2 | Opennebula Context version default 5.10.4, tests OK
Fedora | 31 | Opennebula Context version default 5.10.4, tests OK
Fedora | 32 | Opennebula Context version default 5.10.4, tests OK
Fedora | 33 | Opennebula Context version default 5.10.4, tests OK
Ubuntu | 20.04 | Opennebula Context version default 5.10.4, tests OK
Ubuntu | 18.04 | Opennebula Context version default 5.10.4, tests OK
Archlinux | latest | Opennebula Context version default 5.10.4, tests OK
Alpine | 3.12 | Opennebula Context version default 5.10.4, tests OK

* `make image/vagrant distrib=centos version=8.2` - Build Vagrant Qcow2.

* `make docs/serve` - Start the live-reloading docs server.
* `make docs/build` - Build the documentation site.
* `make image/vagrant` - Build vagrant libvirt Image.
* `make venv` - Init a virtualenv Python at the root of the project.
* `make clean` - Clean the projet delete venv build packer_cache.
* `make version` - Print Version of all project's dependencies.
## Ajout version

## Project layout
    Makefile      # Entry point Project manager
    mkdocs.yml    # The documentation configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.
    data/         # OS packer template and var files
        distrib/  #
        ...       #
    http/         # Directory serve in http by packer during the installation process
        distrib/  #
        ...       #
    provisionners/#
        ansible/  #

## References
- For Packer documentation visit [Packer](https://www.packer.io/docs/).
- For Ansible documentation visit [Ansible](https://docs.ansible.com/ansible/latest/index.html).
- For mkdocs documentation visit [mkdocs.org](https://www.mkdocs.org).

*Above: Cupcake indexer in progress*
