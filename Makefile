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
.SHELLFLAGS             := -eu -o pipefail -c

.DEFAULT_GOAL := help

include mklib/common.mk
include mklib/packer.mk

PACKER_ENV = \
	PACKER_LOG=$(packer_log) \
	PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins" \
	PACKER_CACHE_DIR="$(shell pwd)/.packer_cache"

ssh_public_key_file     ?= $(HOME)/.ssh/id_ed25519.pub
ssh_private_key_file    ?= $(HOME)/.ssh/id_ed25519

SSH_VARS = \
	-var "ssh_public_key_file=$(ssh_public_key_file)" \
	-var "ssh_private_key_file=$(ssh_private_key_file)"

.PHONY: help init build/doc tests/scripts
.PHONY: validate/rocky-9.7-standard-vagrant-uefi.ks

help: .default-menu ## Show available targets and descriptions
	@echo "Goldimages — Packer $(packer_version)"

init: packer ## Install required Packer plugins
	PACKER_PLUGIN_PATH="$(shell pwd)/.packer/plugins" ./packer init .

# ==============================================================================
# Kickstart validation
# ==============================================================================

validate/rocky-9.7-standard-vagrant-uefi.ks: ## Validate Rocky 9.7 standard Vagrant Kickstart
	@mkdir -p build
	podman run --rm \
		-v "$(shell pwd):/work:Z" \
		-w /work \
		rockylinux:9 \
		bash -c "dnf -y install pykickstart >/dev/null && ksvalidator --version=RHEL9 http/rocky/9.7/standard-vagrant-uefi.ks" \
		| tee -a build/ksvalidator-rocky-9.7-standard-vagrant-uefi.ks.log



# ------------------------------------------------------------------------------
# Debian 13.6 - Libvirt
# ------------------------------------------------------------------------------

build/debian-13.6-libvirt.standard.uefi.qcow2: data/debian/13.6/standard.libvirt.pkrvars.hcl init .goldimages venv ## Build Debian 13.6 Libvirt Standard UEFI cloud image
	@$(call green,Build Debian 13.6 Libvirt Standard UEFI cloud image)
	$(VENV_ACTIVATE) && \
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/debian/13.6/standard.libvirt.pkrvars.hcl \
		-only=debian-libvirt.qemu.debian_cloud \
		-on-error=abort .

build/debian-13.6-libvirt.production.uefi.qcow2: data/debian/13.6/production.libvirt.pkrvars.hcl init .goldimages venv ## Build Debian 13.6 Libvirt Production UEFI cloud image
	@$(call green,Build Debian 13.6 Libvirt Production UEFI cloud image)
	$(VENV_ACTIVATE) && \
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/debian/13.6/production.libvirt.pkrvars.hcl \
		-only=debian-libvirt.qemu.debian_cloud \
		-on-error=abort .

# ==============================================================================
# Rocky Linux legacy targets
# ==============================================================================

build/rocky-9.7-vagrant.standard.uefi.box: data/rocky/9.7/standard.pkrvars.hcl init .goldimages ## Build Rocky 9.7 Vagrant Standard UEFI box
	@$(call green,Build Rocky 9.7 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.7/standard.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.standard.uefi.box: data/rocky/9.6/standard.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Vagrant Standard UEFI box
	@$(call green,Build Rocky 9.6 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/standard.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.production.uefi.box: data/rocky/9.6/production.vagrant.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Vagrant Production UEFI box
	@$(call green,Build Rocky 9.6 Vagrant Production UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/production.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.samba.uefi.box: data/rocky/9.6/samba.vagrant.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Vagrant Samba UEFI box
	@$(call green,Build Rocky 9.6 Vagrant Samba UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/samba.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-vagrant.custom.uefi.box: data/rocky/9.6/custom.vagrant.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Vagrant Custom UEFI box
	@$(call green,Build Rocky 9.6 Vagrant Custom UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/custom.vagrant.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-libvirt.standard.uefi.qcow2: data/rocky/9.6/standard.libvirt.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Libvirt Standard UEFI image
	@$(call green,Build Rocky 9.6 Libvirt Standard UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		--var-file=data/rocky/9.6/standard.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

build/rocky-9.6-libvirt.production.uefi.qcow2: data/rocky/9.6/production.libvirt.pkrvars.hcl init .goldimages ## Build Rocky 9.6 Libvirt Production UEFI image
	@$(call green,Build Rocky 9.6 Libvirt Production UEFI image)
	$(PACKER_ENV) ./packer build -machine-readable \
		$(SSH_VARS) \
		-var 'headless=true' \
		--var-file=data/rocky/9.6/production.libvirt.pkrvars.hcl \
		-only=libvirt.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# CentOS Stream legacy targets
# ==============================================================================

build/centos-9-vagrant.standard.uefi.box: data/centos/9/standard-vagrant-uefi.pkrvars.hcl init .goldimages ## Build CentOS 9 Vagrant Standard UEFI box
	@cat mklib/Goldimages.art
	@$(call green,Build CentOS 9 Vagrant Standard UEFI box)
	$(PACKER_ENV) ./packer build -machine-readable \
		--var-file=data/centos/9/standard-vagrant-uefi.pkrvars.hcl \
		-only=vagrant.qemu.rhel \
		-on-error=abort .

# ==============================================================================
# Documentation
# ==============================================================================

build/doc: README.md doc/eisvogel.latex doc/latex-headers.tex doc/elephant.png ## Build PDF documentation from README
	docker run --rm \
		--volume "$(CURDIR)/doc:/data" \
		--volume "$(CURDIR)/README.md:/data/goldimage.md:ro" \
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

tests/scripts: ## Check shell scripts with ShellCheck
	@shellcheck \
		--shell=bash \
		--exclude=SC2086,SC2236,SC2094 \
		scripts/*.sh

# Build targets are aliases; Packer controls the artifact filenames.
BUILD_TARGETS := build/debian-13.6-libvirt.standard.uefi.qcow2 \
	build/debian-13.6-libvirt.production.uefi.qcow2 \
	build/rocky-9.7-vagrant.standard.uefi.box \
	build/rocky-9.6-vagrant.standard.uefi.box \
	build/rocky-9.6-vagrant.production.uefi.box \
	build/rocky-9.6-vagrant.samba.uefi.box \
	build/rocky-9.6-vagrant.custom.uefi.box \
	build/rocky-9.6-libvirt.standard.uefi.qcow2 \
	build/rocky-9.6-libvirt.production.uefi.qcow2 \
	build/centos-9-vagrant.standard.uefi.box
.PHONY: $(BUILD_TARGETS)

# Compatibility with the quick-start commands in README.md.
.PHONY: build/rocky-9.6_vagrant.standard.uefi.box build/rocky-9.6-standard-libvirt.uefi.qcow2
build/rocky-9.6_vagrant.standard.uefi.box: build/rocky-9.6-vagrant.standard.uefi.box
build/rocky-9.6-standard-libvirt.uefi.qcow2: build/rocky-9.6-libvirt.standard.uefi.qcow2
