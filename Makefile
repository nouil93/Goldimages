# ==============================================================================
# GoldImages Makefile
# ==============================================================================
#
# Copyright (c) 2000-2026 Frédéric Delacour
# Author: Frédéric Delacour
#
# Description:
#   Automation entrypoint for GoldImages image builds, validation, packaging,
#   and documentation generation using Packer, Podman, and Pandoc.
#
# ==============================================================================

PROJECT                 := Goldimages
description             := standardizes and automates building system process.
packer_version          := 1.13.1
packer_url              := https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_linux_amd64.zip
packer_SHA256SUMS_url   := https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_SHA256SUMS
packer_log              ?= 0

SHELL                   := /bin/bash
.SHELLFLAGS             := -e -c

.DEFAULT_GOAL := help

include mklib/common.mk
include mklib/packer.mk

PACKER_ENV = \
	PACKER_LOG=$(packer_log) \
	PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins" \
	PACKER_CACHE_DIR="$(shell pwd)/.packer_cache"

SSH_VARS = \
	-var "ssh_public_key_file=$(HOME)/.ssh/id_ed25519.pub" \
	-var "ssh_private_key_file=$(HOME)/.ssh/id_ed25519"

.PHONY: help init build/doc tests/scripts
.PHONY: validate/rocky-9.7-standard-vagrant-uefi.ks

help: .default-menu
	@echo "packer version: $(packer_version)"

init:
	PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins" ./packer init .

# ==============================================================================
# Kickstart validation
# ==============================================================================

validate/rocky-9.7-standard-vagrant-uefi.ks:
	@mkdir -p build
	podman run --rm \
		-v "$(shell pwd):/work:Z" \
		-w /work \
		rockylinux:9 \
		bash -c "dnf -y install pykickstart >/dev/null && ksvalidator --version=RHEL9 http/rocky/9.7/standard-vagrant-uefi.ks" \
		| tee -a build/ksvalidator-rocky-9.7-standard-vagrant-uefi.ks.log

# ==============================================================================
# Rocky Linux 10.1
# ==============================================================================

# ------------------------------------------------------------------------------
# Rocky Linux 10.1 - Vagrant
# ------------------------------------------------------------------------------

build/rocky-10.1-vagrant.standard.uefi.box: init .goldimages venv
	@$(call green,Check Rocky 10.1 Vagrant Standard UEFI box)
	$(VENV_ACTIVATE) && ansible-playbook --syntax-check provisioners/ansible/vagrant.yml
	$(VENV_ACTIVATE) && ansible-lint provisioners/ansible/vagrant.yml
	@$(call green,Build Rocky 10.1 Vagrant Standard UEFI box)
	$(VENV_ACTIVATE) && \
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/standard.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-10.1-vagrant.production.uefi.box: init .goldimages
	@$(call green,Build Rocky 10.1 Vagrant Production UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/production.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-10.1-vagrant.samba.uefi.box: init .goldimages
	@$(call green,Build Rocky 10.1 Vagrant Samba UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/samba.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-10.1-vagrant.custom.uefi.box: init .goldimages
	@$(call green,Build Rocky 10.1 Vagrant Custom UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/custom.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

# ------------------------------------------------------------------------------
# Rocky Linux 10.1 - Libvirt
# ------------------------------------------------------------------------------

build/rocky-10.1-libvirt.standard.uefi.qcow2: init .goldimages
	@$(call green,Build Rocky 10.1 Libvirt Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/standard.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/rocky-10.1-libvirt.production.uefi.qcow2: init .goldimages
	@$(call green,Build Rocky 10.1 Libvirt Production UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		-var 'headless=true' \
		--var-file=data/rocky/10.1/production.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

# ------------------------------------------------------------------------------
# Rocky Linux 10.1 - Nutanix
# ------------------------------------------------------------------------------

build/rocky-10.1-nutanix.standard.uefi.qcow2: init
	@$(call green,Build Rocky 10.1 Nutanix Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/10.1/standard.nutanix.pkrvars.hcl \
		-only=nutanix.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# Rocky Linux legacy targets
# ==============================================================================

build/rocky-9.7-vagrant.standard.uefi.box: init .goldimages
	@$(call green,Build Rocky 9.7 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.7/standard.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.standard.uefi.box: init .goldimages
	@$(call green,Build Rocky 9.6 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/standard.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.production.uefi.box: init .goldimages
	@$(call green,Build Rocky 9.6 Vagrant Production UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/production.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.samba.uefi.box: init .goldimages
	@$(call green,Build Rocky 9.6 Vagrant Samba UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/samba.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.custom.uefi.box: init .goldimages
	@$(call green,Build Rocky 9.6 Vagrant Custom UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/custom.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-libvirt.standard.uefi.qcow2: init .goldimages
	@$(call green,Build Rocky 9.6 Libvirt Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/standard.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-libvirt.production.uefi.qcow2: init .goldimages
	@$(call green,Build Rocky 9.6 Libvirt Production UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		-var 'headless=true' \
		--var-file=data/rocky/9.6/production.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# RHEL legacy targets
# ==============================================================================

build/redhat-9.6-vagrant.standard.uefi.qcow2: init
	@$(call green,Build RHEL 9.6 Vagrant Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=redhat9.6.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/redhat-9.6-libvirt.standard.uefi.qcow2: init
	@$(call green,Build RHEL 9.6 Libvirt Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=redhat9.6.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/redhat-9.6-nutanix.standard.uefi.qcow2: init
	@$(call green,Build RHEL 9.6 Nutanix Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=redhat9.6.pkrvars.hcl \
		-only=nutanix.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# CentOS Stream legacy targets
# ==============================================================================

build/centos-9-vagrant.standard.uefi.box: init .goldimages
	@cat mklib/Goldimages.art
	@$(call green,Build CentOS 9 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=data/centos9-vagrant-standard-uefi.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/centos-9-libvirt.standard.uefi.qcow2: init .goldimages
	@cat mklib/Goldimages.art
	@$(call green,Build CentOS 9 Libvirt Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=data/centos9-libvirt-standard-uefi.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/centos-9-nutanix.standard.uefi.qcow2: init
	@$(call green,Build CentOS 9 Nutanix Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=data/centos9-nutanix-standard-uefi.pkrvars.hcl \
		-only=nutanix.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# Documentation
# ==============================================================================

build/doc:
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

# ==============================================================================
# Tests
# ==============================================================================

tests/scripts:
	@shellcheck \
		--shell=bash \
		--exclude=SC2086,SC2236,SC2094 \
		scripts/*.sh