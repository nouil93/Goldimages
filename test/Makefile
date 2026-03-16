PACKER ?= packer

build-vagrant:
	$(PACKER) build -only=vagrant-box .

build-nutanix:
	$(PACKER) build -only=nutanix-image .

build-all:
	$(PACKER) build .
