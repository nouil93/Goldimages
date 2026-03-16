##
# (C) Copyright 2000-2026
# Frédéric Delacour, <frederic.delacour@gmail.com>.
#

PROJECT					:=	Goldimages
description				=	"standardizes and automates building system process."
packer_version			=	1.13.1
packer_url				=	https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_linux_amd64.zip
packer_SHA256SUMS_url	=	https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_SHA256SUMS
packer_log 				?=	0

shell					:=	/bin/bash -e

.DEFAULT_GOAL := help

.PHONY: help
help: .default-menu
	@echo "packer version: $(packer_version)"

include mklib/common.mk
include mklib/packer.mk

.PHONY: init
init:
	PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins" ./packer init .

.PHONY: .validate/rocky-9.7_standard-vagrant-uefi.ks
validate/rocky-9.7_standard-vagrant-uefi.ks:
	# ksvalidator --version=RHEL9 http/rocky/9.7/standard-vagrant-uefi.ks	
	podman run --rm \
	  -v "$(shell pwd):/work:Z" \
	  -w /work \
	  rockylinux:9 \
	  bash -c "dnf -y install pykickstart >/dev/null && ksvalidator --version=RHEL9 http/rocky/9.7/standard-vagrant-uefi.ks" | tee -a build/ksvalidator-rocky-9.7_standard-vagrant-uefi.ks.log
	

build/rocky-9.7_vagrant.standard.uefi.box: init .goldimages ## Build Rocky 9.7 standard partition 100Gb
	$(call green, Build Rocky 9.7 Vagrant Standart Partition UEFI box image')
	PACKER_LOG=$(packer_log) PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins"  PACKER_CACHE_DIR="$(shell pwd)/.packer_cache"  ./packer  build -on-error=abort -machine-readable --var-file=data/rocky/9.7/standard.pkrvars.hcl -only=vagrant.qemu.rhel .

build/rocky-9.6_vagrant.standard.uefi.box: init .goldimages ## Build Rocky 9.6 standard partition 100Gb
	$(call green, Build Rocky 9.6 Vagrant Standart Partition UEFI box image')
	PACKER_LOG=$(packer_log) ./packer build -machine-readable --var-file=data/rocky/9.6/standard.pkrvars.hcl -only=vagrant.qemu.rhel .

build/rocky-9.6-production-vagrant-uefi.box: init .goldimages ## Build Rocky 9.6 standard partition 100Gb
	$(call green, Build Rocky 9.6 Vagrant Standart Partition UEFI box image')
	./packer build -machine-readable --var-file=data/rocky/9.6/production.vagrant.pkrvars.hcl -only=vagrant.qemu.rhel .

build/rocky-9.6-samba-vagrant-uefi.box: init .goldimages ## Build Rocky 9.6 Samba partition 50Gb
	$(call green, Build Rocky 9.6 Vagrant Standart Partition UEFI box image')
	./packer build -machine-readable --var-file=data/rocky/9.6/samba.vagrant.pkrvars.hcl -only=vagrant.qemu.rhel .

build/rocky-9.6-vagrant-custom-uefi.box: init .goldimages ## Build Rocky 9.6 Custom partition 50Gb
	$(call green, Build Rocky 9.6 Vagrant Custom Partition UEFI box image')
	PACKER_LOG=$(packer_log) ./packer build -machine-readable --var-file=data/rocky/9.6/custom.vagrant.pkrvars.hcl -only=vagrant.qemu.rhel -on-error=abort .

build/rocky-9.6-standard-libvirt.uefi.qcow2: init .goldimages
	$(call green, Build Rocky 9.6 Libvirt Standart Partition UEFI box image')
	./packer build -machine-readable --var-file=data/rocky/9.6/standard.libvirt.pkrvars.hcl -only=libvirt.qemu.rhel -on-error=abort .

build/rocky-9.6-production-libvirt.uefi.qcow2: init .goldimages
	$(call green, Build Rocky 9.6 Libvirt Production Partition UEFI box image')
	./packer build \
		-machine-readable \
		-var 'headless=true' \
		--var-file=data/rocky/9.6/production.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/rocky9.6_nutanix.standard.uefi.qcow2: init
	./packer build --var-file=rocky9.6.pkrvars.hcl -only=nutanix.qemu.rhel .

build/redhat9.6_vagrant.standard.uefi.qcow2: init
	./packer build --var-file=redhat9.6.pkrvars.hcl -only=vagrant.qemu.rhel .

build/redhat9.6_libvirt.standard.uefi.qcow2: init
	./packer build --var-file=redhat9.6.pkrvars.hcl -only=libvirt.qemu.rhel .

build/redhat9.6_nutanix.standard.uefi.qcow2: init
	./packer build --var-file=redhat9.6.pkrvars.hcl -only=nutanix.qemu.rhel .

build/centos9_nutanix.standard.uefi.qcow2: init
	./packer build --var-file=data/centos9-nutanix-standard-uefi.pkrvars.hcl -only=nutanix.qemu.rhel .

build/centos9_libvirt.standard.uefi.qcow2: init .goldimages ## Build Centos 9 standard partition 40Gb
	@cat mklib/Goldimages.art
	$(call green, Build Centos 9 Libvirt Standart Partition UEFI qcow2 image')
	./packer build --var-file=data/centos9-libvirt-standard-uefi.pkrvars.hcl -only=vagrant.qemu.rhel .

build/centos9_vagrant.standard.uefi.box: init ## Build Centos 9 standard partition 40Gb
	@cat mklib/Goldimages.art
	$(call green, Build Centos 9 Vagrant Standart Partition UEFI qcow2 image')
	./packer build --var-file=data/centos9-vagrant-standard-uefi.pkrvars.hcl -only=vagrant.qemu.rhel .

.PHONY:
build/doc: ## Build pdf documentation
	docker run --rm \
		--volume $(shell pwd)/doc:/data \
		--workdir /data \
		rstropek/pandoc-latex \
			--output=goldimages-$(shell date +"%d%m%y-%H-%M").pdf \
			--from markdown+raw_tex \
			--pdf-engine=xelatex \
			--highlight-style=tango \
			--template eisvogel.latex \
			--toc \
			--variable=date:"$(shell date '+%B\ %d,\ %Y')" \
			--variable=monofont:"DejaVu Sans Mono" \
			--variable=titlepage-logo:"elephant.png" \
			-t latex \
			--number-sections \
			--include-in-header=latex-headers.tex \
			goldimage.md