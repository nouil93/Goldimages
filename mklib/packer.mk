packer: ## Packer download and verify
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
	@./packer plugins install github.com/hashicorp/qemu

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