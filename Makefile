SHELL := /bin/bash
STOW_TARGET = $$HOME
SCRIPTS = .lib/scripts
TEMPLATES = .lib/templates
# -----------------------------------------------------------------------------
# Set default options
HOOK = stow
STOW_OPTIONS =
# Bash completions seems to handle this fine, but not zsh :/
STOWABLE = $(shell echo */ | sed 's;/;;g')
# -----------------------------------------------------------------------------
define USAGE
  Usage:
    make [init|stow|unstow|restow|install|uninstall] [all|pkg-name [pkg-name2 ...]]
    make help
endef
# -----------------------------------------------------------------------------
# if the *first* argument is 'init,'
ifeq (init, $(firstword $(MAKECMDGOALS)))
init:
	@$(SCRIPTS)/init-pkg $(filter-out $@, $(MAKECMDGOALS))
else ifeq (stow, $(firstword $(MAKECMDGOALS)))
stow:
	@echo "$$(tput setaf 3)Setting: $$(tput setaf 5)STOW_OPTIONS =, HOOK = $@$$(tput sgr0)"
	$(eval HOOK = stow)
	$(eval STOW_OPTIONS =)
else ifeq (unstow, $(firstword $(MAKECMDGOALS)))
# then set variables accordingly
unstow:
	@echo "$$(tput setaf 3)Setting: $$(tput setaf 5)STOW_OPTIONS = -D, HOOK = $@$$(tput sgr0)"
	$(eval HOOK = unstow)
	$(eval STOW_OPTIONS = -D)
else ifeq (restow, $(firstword $(MAKECMDGOALS)))
# Stow has -R option, but use this, to trigger *-unstow and *-stow hooks
restow:
	@make unstow $(filter-out $@, $(MAKECMDGOALS))
	@make        $(filter-out $@, $(MAKECMDGOALS))
else ifeq (install, $(firstword $(MAKECMDGOALS)))
install:
	@echo "$$(tput setaf 3)Setting: $$(tput setaf 5)STOW_OPTIONS =, HOOK = $@$$(tput sgr0)"
	$(eval HOOK = install)
	$(eval STOW_OPTIONS =)
else ifeq (uninstall, $(firstword $(MAKECMDGOALS)))
uninstall:
	@echo "$$(tput setaf 3)Setting: $$(tput setaf 5)STOW_OPTIONS = -D, HOOK = $@$$(tput sgr0)"
	$(eval HOOK = uninstall)
	$(eval STOW_OPTIONS = -D)
endif
# -----------------------------------------------------------------------------
all: $(STOWABLE)

help:
	@: $(info $(USAGE))
# -----------------------------------------------------------------------------
$(STOWABLE): stow-available
	@echo "$$(tput setaf 3)Processing: $$(tput setaf 5)$@$$(tput sgr0)"
	@$(SCRIPTS)/process-hooks "$@" "pre" "$(HOOK)"
	@stow -v -t "$(STOW_TARGET)" \
		--no-folding \
		--ignore='^README.md$$' \
		--ignore='^hooks$$' \
 		$(STOW_OPTIONS) $@
	@$(SCRIPTS)/process-hooks "$@" "post" "$(HOOK)"
# -----------------------------------------------------------------------------
stow-available:
	@command -v stow > /dev/null || make install gnu-stow
# -----------------------------------------------------------------------------
.PHONY: $(STOWABLE)
