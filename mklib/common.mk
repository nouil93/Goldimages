# ==============================================================================
#  Makefile - Infrastructure Automation & Packaging
# ==============================================================================
#
#  Author: Frédéric Delacour
#  Project: Infrastructure Automation Blueprint
#
#  Description:
#    This Makefile provides automation for:
#      - Python virtual environment management
#      - Dependency installation
#      - Build/export packaging (tar.gz)
#      - Cleanup routines
#
#    Designed for reproducible DevOps workflows and CI/CD integration.
#
#  Usage:
#    make venv        # Create Python virtual environment
#    make export      # Create versioned archive
#    make clean       # Clean cache/build artifacts
#    make info        # Debug environment variables
#
#  Requirements:
#    - GNU Make
#    - Python 3.x
#    - Git (optional, for versioned export)
#
#  License:
#    MIT (or your choice)
#
# ==============================================================================

VENV_NAME     ?= venv
PYTHON        = ${VENV_NAME}/bin/python3
VENV_ACTIVATE = . $(VENV_NAME)/bin/activate
cyan          = echo -e "\x1b[36m\#\# $1\x1b[0m"
pink          = echo -e "\x1b[35m\#\# $1\x1b[0m"
blue   		  = echo -e "\x1b[34m\#\# $1\x1b[0m"
yellow 		  = echo -e "\x1b[33m\#\# $1\x1b[0m"
green 		  = echo -e "\x1b[32m\#\# $1\x1b[0m"
red  		  = echo -e "\x1b[31m\#\# $1\x1b[0m"
#

TS := $(shell date +%Y%m%d-%H%M%S)
GIT_SHA := $(shell git rev-parse --short HEAD 2>/dev/null || echo nogit)
DIST_DIR := dist
ARCHIVE := $(DIST_DIR)/$(PROJECT)-$(TS)-$(GIT_SHA).tar.gz

SHELL=/bin/bash

.PHONY: venv export clean clean-builds info

venv: $(VENV_NAME)/bin/activate ## Create or update the Python environment
$(VENV_NAME)/bin/activate: requirements.txt
	test -d $(VENV_NAME) || python3 -m venv $(VENV_NAME)
	[ ! -z $(proxy) ] && \
	${PYTHON} -m pip install --proxy ${proxy} --upgrade pip && \
	${PYTHON} -m pip install --proxy ${proxy} --upgrade --requirement requirements.txt \
	|| \
	${PYTHON} -m pip install --upgrade pip && \
	${PYTHON} -m pip install --upgrade --requirement requirements.txt
	touch $(VENV_NAME)/bin/activate
 

.PHONY: .default-menu
.default-menu:
	@echo -ne "\x1b[33m            .MMM..:MMMMMMM                  $(PROJECT) \x1b[0m\n"
	@echo -ne "\x1b[33m           MMMMMMMMMMMMMMMMMM               OS: Red Hat Enterprise Linux \x1b[0m\n"
	@echo -ne "\x1b[33m           MMMMMMMMMMMMMMMMMMMM.            OS: Rocky Linux\x1b[0m\n"
	@echo -ne "\x1b[33m          MMMMMMMMMMMMMMMMMMMMMM            OS: Centos Linux\x1b[0m\n"
	@echo -ne "\x1b[33m         ,MMMMMMMMMMMMMMMMMMMMMM:           \x1b[0m\n"
	@echo -ne "\x1b[33m         MMMMMMMMMMMMMMMMMMMMMMMM           \x1b[0m\n"
	@echo -ne "\x1b[33m   .MMMM'  MMMMMMMMMMMMMMMMMMMMMM           \x1b[0m\n"
	@echo -ne "\x1b[33m  MMMMMM    \`MMMMMMMMMMMMMMMMMMMM.          \x1b[0m\n"
	@echo -ne "\x1b[33m MMMMMMMM      MMMMMMMMMMMMMMMMMM .         \x1b[0m\n"
	@echo -ne "\x1b[33m MMMMMMMMM.       \`MMMMMMMMMMMMM' MM.       \x1b[0m\n"
	@echo -ne "\x1b[33m MMMMMMMMMMM.                     MMMM      \x1b[0m\n"
	@echo -ne "\x1b[33m \`MMMMMMMMMMMMM.                 ,MMMMM.    \x1b[0m\n"
	@echo -ne "\x1b[33m  \`MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.   \x1b[0m\n"
	@echo -ne "\x1b[33m     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   \x1b[0m\n"
	@echo -ne "\x1b[33m       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:   \x1b[0m\n"
	@echo -ne "\x1b[33m          MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    \x1b[0m\n"
	@echo -ne "\x1b[33m             \`MMMMMMMMMMMMMMMMMMMMMMMM:     \x1b[0m\n"
	@echo -ne "\x1b[33m                 \`\`MMMMMMMMMMMMMMMMM'       \x1b[0m\n\n"
	@echo -ne "\x1b[33m$(description) \x1b[0m\n\n"
	@awk '/^[^[:space:]:]+:.*##/ { target = $$0; sub(/:.*/, "", target); description = $$0; sub(/^.*##[[:space:]]*/, "", description); targets[++count] = target; descriptions[count] = description; if (length(target) > width) width = length(target) } END { for (i = 1; i <= count; i++) printf "  %-*s  %s\n", width, targets[i], descriptions[i] }' $(MAKEFILE_LIST)

# Test values of variables - for debug purposes
info: ## Show build environment variables
	@echo "--- Compilation commands --- "
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

$(DIST_DIR):
	@mkdir -p $(DIST_DIR)

.PHONY: export
export: | $(DIST_DIR) ## Export a source archive
	@echo "Exporting snapshot -> $(ARCHIVE)"
	@if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
		git archive --format=tar.gz --prefix=$(PROJECT)/ -o "$(ARCHIVE)" HEAD; \
	else \
		tar --exclude='./.git' \
		    --exclude='./.venv' --exclude='./venv' \
			--exclude='./packer' --exclude='.packer_cache' --exclude='.packer'\
		    --exclude='./__pycache__' --exclude='./.pytest_cache' \
		    --exclude='./.mypy_cache' --exclude='./.ruff_cache' \
		    --exclude='./dist' --exclude='./build' --exclude='./output' --exclude='./_build' \
			--exclude='./build' \
		    -czf "$(ARCHIVE)" .; \
	fi
	@echo "Done: $(ARCHIVE)"

.PHONY: clean
clean: ## Remove caches and generated build artifacts
	rm -rf __pycache__ .pytest_cache .mypy_cache .ruff_cache dist build

.PHONY: clean-builds
clean-builds: ## Remove output/_build
	rm -rf output/_build
	
