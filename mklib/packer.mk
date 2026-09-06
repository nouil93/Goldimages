# ------------------------------------------------------------------------------
# Packer bootstrap
# Downloads, verifies, installs, and prepares the local Packer binary.
# Author: Frédéric Delacour
# ------------------------------------------------------------------------------

PACKER_BIN          ?= ./packer
PACKER_ZIP          := $(notdir $(packer_url))
PACKER_SHA256SUMS   := $(notdir $(packer_SHA256SUMS_url))


packer: ## Packer download and verify
	@set -eu -o pipefail; \
	bootstrap_dir=$$(mktemp -d); \
	trap 'rm -rf "$$bootstrap_dir"' EXIT; \
	cd "$$bootstrap_dir"; \
	curl $(if $(proxy),--proxy "$(proxy)",) --fail --location --show-error --output "$(PACKER_ZIP)" "$(packer_url)"; \
	curl $(if $(proxy),--proxy "$(proxy)",) --fail --location --show-error --output "$(PACKER_SHA256SUMS)" "$(packer_SHA256SUMS_url)"; \
	awk '$$2 == "$(PACKER_ZIP)" { print }' "$(PACKER_SHA256SUMS)" > selected.sha256; \
	test -s selected.sha256; \
	sha256sum --check selected.sha256; \
	unzip -o "$(PACKER_ZIP)" packer; \
	install -m 755 packer "$(CURDIR)/packer"

.PHONY: .goldimages
.goldimages: packer ## Print Logo
	@echo -ne "\x1b[33m	 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠔⠋⠈⠑⠤⡀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠖⠉⣀⣀⠀⠀⠀⠀⠈⠓⠤⡀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⣒⣉⡀⢀⣤⡛⢿⣾⣤⣀⠀⠀⠀⠀⠈⣓⢄⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠒⠁⠸⣿⣿⡷⣷⣿⣿⣦⡝⠻⠿⠃⠀⢀⣤⣾⠿⠛⡄⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠁  ⠀⠀ ⠙⠻⣾⣋⣿⣯⠀⠀⢀⣠⣾⠟⠋⠀⠀⠀⢱⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠁⠀GOLDIMAGE⠈⠛⠺⢋⣤⣶⠿⠛⠁⠀⠀⠀⠀⠀⠀⡆	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⣠⠔⠊⢀⣀⡰⣾⣦⡀⠀⠀⠀  ⠀⠀⠀⢀⣠⣶⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⢀⡠⠊	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⣴⣯⡉⠀⠀⠳⢿⣿⣯⡛⢽⣦⡄⠀⠀  ⣠⣶⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⡀⡠⠖⠁⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⢠⠉⠻⢮⡦⡀⠀⠈⠹⣿⣿⡌⠁⠀⢀⣠⣶⡽⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⣀⠜⠉⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⡌⠀⠀⠀⠹⢮⡢⡄⠀⠙⠋⢀⡠⣶⡽⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⢠⠃⠀⠀⠀⠀⠈⠻⢾⣷⡴⣖⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠑⢄⠀⠀⠀⠀⠀⠀⠙⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⣀⠔⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠑⢄⠀⠀⠀⢀⡠⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠤⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀	\x1b[0m\n"
	@echo -ne "\x1b[33m												\x1b[0m\n"