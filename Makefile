##
# (C) Copyright 2000-2020
# Frédéric Delacour, frederic.delacour@gmail.com.
#

projet					=	Goldimages
packer_version			=	1.6.5
packer_url				=	https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_linux_amd64.zip
packer_SHA256SUMS_url	=	https://releases.hashicorp.com/packer/$(packer_version)/packer_$(packer_version)_SHA256SUMS

isoout 					= 	soclelinux-2016.0.14-custom.iso
distrib 				?= 	fedora
version 				?= 	32
# model					?=  server, desktop, xrdp or any custom alternative you add yourself
model 					?= 	server
# type 					?= 	vagrant, opennebula, or any alternate you add yourself
type					?=
# packer_log 				?=	1 #
packer_log 				?=	0
headless 				?=	false
cpu 					?= 	4
memory 					?= 	2048
output_directory 		?= 	build
proxy 					?=
vm_name 				:= 	$(distrib)$(version)-$(type)-$(shell date +'%Y-%m-%d')
# packer debuging
onerror					=	cleanup # or ask, retry
# https://www.packer.io/docs/other/debugging.html

###
packer_cmd = $(VENV_ACTIVATE) && \
			CHECKPOINT_DISABLE=1 \
			PACKER_LOG=$(packer_log) \
			./packer build -on-error=$(onerror) \
				-var 'headless=$(headless)' \
				-var 'memory=$(memory)' \
				-var 'cpus=$(cpu)' \
				-var 'vm_name=$(vm_name)' \
				-var-file=data/$(distrib)/$(version)/$(model).json \
				data/$(distrib)/$(type).json

.PHONY: help
.DEFAULT: help
help: .default-menu
	@echo "make image  - Build image"
	@echo "  default params: distrib=fedora version=$(version)"
	@echo "  distrib={fedora (22 -> 32) debian (8 -> 10) ubuntu (12.04 -> 20.04) arch centos (5 -> 8.2)}"
	@echo "make tests  - Run self tests"
	@echo "packer version: $(packer_version)"

include mklib/common.mk

packer:
	http_proxy=$(proxy) \
	https_proxy=$(proxy) \
	curl -O $(packer_url) && \
	curl -O $(packer_SHA256SUMS_url)
	sha256sum -c $(shell basename $(packer_SHA256SUMS_url)) 2>&1 | \
		grep $(shell basename $(packer_url))
	@unzip $(shell basename $(packer_url))
	@chmod 755 packer
	@rm $(shell basename $(packer_url))
	@rm $(shell basename $(packer_SHA256SUMS_url))

soclelinux-2016-0.14.iso:
	@curl -O ftp://venezia.appli.dgfip/pub/socle-linux/socle2016_0.14/soclelinux-2016-0.14.iso

soclelinux-2016.0.14-custom.iso: soclelinux-2016-0.14.iso
	@./scripts/buildiso.sh

image/vagrant: type=vagrant
image/vagrant: vm_name = $(distrib)$(version)-$(type)-$(shell date +'%Y-%m-%d')
image/vagrant: $(output_directory)/$(distrib)$(version)-$(type).box
$(output_directory)/$(distrib)$(version)-$(type).box: venv packer
	@cat mklib/Goldimages.art
	@test ! -d $(output_directory) && mkdir $(output_directory) \
	|| $(call green, Directory $(output_directory) already created...')
	@$(call yellow, Packer Build Qemu Image)
	@$(call yellow,  $(vm_name) Type: $(type) headless: $(headless))
	@$(call yellow, memory=$(memory) cpus=$(cpu))
	@$(call yellow, onerror: $(onerror) PACKER_LOG=$(packer_log))
	@$(packer_cmd)
	@cd $(output_directory) && \
	test -f $(vm_name).box && \
	ln -s $(vm_name).box $(distrib)$(version)-$(model).box \
	|| $(call red, 'ERROR $(vm_name).box absent...')
	@test -d $(tmpdir) && rm -rf $(tmpdir) \
	|| $(call red, 'ERROR $(tmpdir) absent...')

image/opennebula: type=opennebula
image/opennebula: vm_name = $(distrib)$(version)-$(type)-$(shell date +'%Y-%m-%d')
image/opennebula: $(output_directory)/$(distrib)$(version)-$(type).qcow2
$(output_directory)/$(distrib)$(version)-$(type).qcow2: venv packer
	@cat mklib/Goldimages.art
	@test ! -d $(output_directory) && mkdir $(output_directory) \
	|| $(call red, Directory $(output_directory) already created...')
	@$(call cyan, packer $(vm_name) Type: $(type) headless: $(headless))
	@$(call cyan, headless=$(headless) )
	@$(call cyan, memory=$(memory) cpus=$(cpu))
	@$(call cyan, PACKER_LOG=$(packer_log))
	@$(packer_cmd)
	@cd $(output_directory) && \
	test -f $(vm_name).qcow2 && \
	ln -s $(vm_name).qcow2 $(distrib)$(version)-$(type).qcow2 \
	|| $(call red, 'ERROR $(vm_name).qcow2 absent...')
	@test -d $(tmpdir) && rm -rf $(tmpdir) \
	|| $(call red, 'ERROR $(tmpdir) absent...')
	@qemu-img check $(output_directory)/$(vm_name).qcow2
	@qemu-img info $(output_directory)/$(vm_name).qcow2

test/test: type=opennebula
test/test: vm_name = $(distrib)$(version)-$(type)-$(shell date +'%Y-%m-%d')
test/test:
	echo $(vm_name)

test/deploy: hostname=$(distrib)$(version)
test/deploy:
	$(VENV_ACTIVATE) && \
	ansible-playbook \
		--inventory inventory-testing.yml provisioners/ansible/vagrant.yml \
		--limit $(distrib)$(version) \
		--user vagrant

images/vagrant:
	@make --no-print-directory image/vagrant onerror=cleanup headless=false \
		distrib=centos version=8.2
	@make --no-print-directory image/vagrant onerror=cleanup headless=false \
		distrib=debian version=10.6
	@make --no-print-directory image/vagrant onerror=cleanup headless=false \
		distrib=ubuntu version=20.04
	@make --no-print-directory image/vagrant onerror=cleanup headless=false \
		distrib=archlinux version=latest
	@make --no-print-directory image/vagrant onerror=ask headless=false \
		distrib=alpine version=3.12

images/opennebula:
	make --no-print-directory image/opennebula distrib=centos version=8.2 onerror=ask
	make --no-print-directory image/opennebula distrib=debian version=10.6 onerror=ask
	make --no-print-directory image/opennebula distrib=fedora version=32 onerror=ask
	make --no-print-directory image/opennebula distrib=ubuntu version=20.04 onerror=ask
	make --no-print-directory image/opennebula distrib=alpine version=3.12 onerror=ask
	make --no-print-directory image/opennebula distrib=archlinux version=latest onerror=ask

clean:
	@rm -rf dist*
	@rm -rf venv
	@rm -rf packer*
	@rm -f *.qcow2
	@rm -f *manifest.json
	@rm -rf .pytest_cache
	@rm -rf $(isoout)

.PHONY: tests
tests:
	@shellcheck \
  		--shell=bash \
  		--exclude=SC2086,SC2236,SC2094 \
  		scripts/buildiso.sh
	./packer inspect data/$(distrib)/$(distrib).json
	./packer validate data/$(distrib)/$(distrib).json

test/image: venv
	if ! $$(vagrant box list | grep -q $(distrib)$(version)-$(model)-test); then \
    	test -f $(output_directory)/$(distrib)$(version)-$(model).box && \
        vagrant box add build/$(distrib)$(version)-$(model).box --name=$(distrib)$(version)-$(model)-test \
        || echo $(distrib)$(version)-$(model).box" not present" && exit 1;  \
    fi;
	box=$(distrib)$(version)-$(model)-test hostname=$(distrib)$(version) \
	envsubst < "data/Vagrantfile" > "Vagrantfile"
	vagrant up
	vagrant ssh-config > ssh.cfg
	$(VENV_ACTIVATE) && py.test -s \
        --hosts=$(distrib)$(version) --tb=long \
        --ssh-config=ssh.cfg test/$(distrib).py
	vagrant destroy -f
	vagrant box remove $(distrib)$(version)-$(model)-test
	virsh vol-delete --pool default $(distrib)$(version)-$(model)-test_vagrant_box_image_0.img
	rm ssh.cfg

version: venv
	@$(VENV_ACTIVATE) && mkdocs --version
	@vagrant --version
	@make --version
	@echo "packer version: $(packer_version)"
	@libvirtd --version
	@kvm --version
	@$(VENV_ACTIVATE) && ansible --version

