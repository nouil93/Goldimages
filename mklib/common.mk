VENV_NAME     ?=venv
PYTHON        =${VENV_NAME}/bin/python3
VENV_ACTIVATE = . $(VENV_NAME)/bin/activate
## func miscelianous
cyan          = echo -e "\x1b[36m\#\# $1\x1b[0m"
pink          = echo -e "\x1b[35m\#\# $1\x1b[0m"
green         = echo -e "\x1b[32m\#\# $1\x1b[0m"
blue          = echo -e "\x1b[34m\#\# $1\x1b[0m"
red           = echo -e "\x1b[31m\#\# $1\x1b[0m"
yellow        = echo -e "\x1b[33m\#\# $1\x1b[0m"
#
backup_dest   ?=~/Documents/20.Backup

GITFLOW_BR_MASTER       = production
GITFLOW_BR_DEVELOP      = master
CURRENT_BRANCH          = $(shell git rev-parse --abbrev-ref HEAD)
GIT_BRANCHES            = $(shell git for-each-ref --format='%(refname:short)' refs/heads/ | xargs echo)
GIT_REMOTES             = $(shell git remote | xargs echo )
GIT_ROOTDIR             = $(shell git rev-parse --show-toplevel)
GIT_HOOKSDIR            = .git/hooks
SRC_HOOKSDIR            = config/hooks
#SRC_HOOKSDIR_TO_ROOTDIR = $(shell git -C "$(GIT_ROOTDIR)/$(SRC_HOOKSDIR)" rev-parse --show-cdup)
SRC_PRECOMMIT_HOOK      = $(wildcard $(SRC_HOOKSDIR)/pre-commit*.sh)

GIT_DATE     = $(shell git log -n 1 --format="%ci")
GIT_HASH     = $(shell git log -n 1 --format="%h")
GITINFO 	 = .$(GIT_HASH).$(GIT_BRANCH)
GIT_REMOTE_URL = $(shell git config --get remote.origin.url)
SHELL        = /bin/bash
VERSION      = $(shell [ -f VERSION ] && head VERSION || echo '0.0.1')
MAJOR        = $(shell echo $(VERSION) | sed "s/^\([0-9]*\).*/\1/")
MINOR        = $(shell echo $(VERSION) | sed "s/[0-9]*\.\([0-9]*\).*/\1/")
PATCH        = $(shell echo $(VERSION) | sed "s/[0-9]*\.[0-9]*\.\([0-9]*\).*/\1/")
# total number of commits
BUILD        = $(shell git log --oneline | wc -l | sed -e "s/[ \t]*//g")
GIT_DIRTY    = $(shell git diff --shortstat 2> /dev/null | tail -n1 )

venv: $(VENV_NAME)/bin/activate
$(VENV_NAME)/bin/activate: requirements.txt
	@test ! -d $(VENV_NAME) && python3 -m venv $(VENV_NAME) || \
		$(call cyan, "Updating VirtualEnv...")
	@[ ! -z $(proxy) ] && \
		${PYTHON} -m pip install --proxy ${proxy} --upgrade pip && \
		${PYTHON} -m pip install --proxy ${proxy} --upgrade --requirement requirements.txt \
	|| \
		${PYTHON} -m pip install --upgrade pip && \
		${PYTHON} -m pip install --upgrade --requirement requirements.txt
	@touch $(VENV_NAME)/bin/activate

backup: clean
	@$(call blue, Backup $(projet))
	@tar --create \
		--gzip \
		-f $(backup_dest)/$(projet)-$(shell date --date='TZ="Europe/Paris"' +%Y-%m-%d).tar.gz \
			--exclude='./tmp' \
			--exclude='./.vagrant' \
			--exclude='./share' \
			--exclude='./bin' \
			--exclude='./.git' \
			--exclude='./.vscode' \
			--exclude='./tmp' \
			--exclude='./packer_cache' \
			--exclude='./build' \
			--exclude='./packer' \
			--exclude='./*.iso' \
			--exclude='./*.box' \
			--exclude='./*.qcow2' \
			--exclude='./*.rpm' \
			--exclude='./builder/.vagrant' \
			--exclude='./*.sql' \
			--exclude='./*.tar.gz' \
			--exclude='./venv' \
			--exclude='./dist*' \
			--exclude='./assets' .
		@stat $(backup_dest)/$(projet)-$(shell date --date='TZ="Europe/Paris"' +%Y-%m-%d).tar.gz

.default-menu:
	@cat mklib/Goldimages.art
	@$(call cyan, $(projet) $(GIT_DATE).)
	@$(call cyan, $(GIT_REMOTE_URL))
	@$(call cyan, date: $(GIT_DATE))
	@$(call cyan, Gitinfo: $(GITINFO))
	@echo "make doc/build      - build $(projet) documentation"
	@echo "make doc/upload     - upload $(projet) documentation"
	@echo "make doc/server     - run development documentation env"
	@echo "make doc/help       - documentation mkdocs"
	@echo "make backup 			- Generate tarball of this projet $(projet)"
	@echo "make clean           - Clean all projet $(projet)"

docs/build: venv
	$(VENV_ACTIVATE) && mkdocs build

.PHONY: docs/serve
docs/serve: venv
	$(VENV_ACTIVATE) && mkdocs serve

.PHONY: docs/help
docs/help: venv
	$(VENV_ACTIVATE) && mkdocs help

docs-upload: docs-build
	cp -r site ../17.Mylabs/repository/www/docs/$(projet)

# Test values of variables - for debug purposes
info:
	@$(call red, $(VERSION).)
	@$(call red, Build $(BUILD).)
	@echo "--- Build $(BUILD)--- "
	@echo "HAS_GITFLOW      -> '$(HAS_GITFLOW)'"
	@echo "--- Directories --- "
	@echo "SUPER_DIR    -> '$(SUPER_DIR)'"
	@echo "--- Git stuff ---"
	@echo "GIT_ROOTDIR            -> '$(GIT_ROOTDIR)'"
	@echo "GITFLOW                -> '$(GITFLOW)'"
	@echo "GITFLOW_BR_MASTER      -> '$(GITFLOW_BR_MASTER)'"
	@echo "GITFLOW_BR_DEVELOP     -> '$(GITFLOW_BR_DEVELOP)'"
	@echo "CURRENT_BRANCH         -> '$(CURRENT_BRANCH)'"
	@echo "GIT_BRANCHES           -> '$(GIT_BRANCHES)'"
	@echo "GIT_REMOTES            -> '$(GIT_REMOTES)'"
	@echo "GIT_DIRTY              -> '$(GIT_DIRTY)'"
	@echo "GIT_SUBTREE_REPOS      -> '$(GIT_SUBTREE_REPOS)'"
	@echo "GIT_BRANCHES_TO_UPDATE -> '$(GIT_BRANCHES_TO_UPDATE)'"
	@echo "GIT_HOOKSDIR           -> '$(GIT_HOOKSDIR)'"
	@echo "SRC_HOOKSDIR           -> '$(SRC_HOOKSDIR)'"
	@echo "SRC_HOOKSDIR_TO_ROOTDIR-> '$(SRC_HOOKSDIR_TO_ROOTDIR)'"
	@echo "SRC_PRECOMMIT_HOOK     -> '$(SRC_PRECOMMIT_HOOK)'"
	@echo ""
	@echo "Consider running 'make versioninfo' to get info on git versionning variables"