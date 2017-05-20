SHELL := /bin/bash
STOW_TARGET = $$HOME
# -----------------------------------------------------------------------------
# Set default options
HOOK = stow
STOW_OPTIONS =
# Bash completions seems to handle this fine, but not zsh :/
STOWABLE = $(shell echo */ | sed 's;/;;g')
# -----------------------------------------------------------------------------
all: $(STOWABLE)

# if the *first* argument is 'stow,'
ifeq (stow, $(firstword $(MAKECMDGOALS)))
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
$(STOWABLE):
	@echo "$$(tput setaf 3)Processing: $$(tput setaf 5)$@$$(tput sgr0)"
	@if [[ -x "$@/hooks/pre-$(HOOK)" ]]; then \
		echo "$$(tput setaf 5)  Running $$(tput setaf 3)pre-$(HOOK)$$(tput setaf 5) hook$$(tput sgr0)"; \
		$(SHELL) "./$@/hooks/pre-$(HOOK)"; \
	fi
	@stow -v -t "$(STOW_TARGET)" \
		--no-folding \
		--ignore='^README.md$$' \
		--ignore='^hooks$$' \
 		$(STOW_OPTIONS) $@
	@if [[ -x "$@/hooks/post-$(HOOK)" ]]; then \
		echo "$$(tput setaf 5)  Running $$(tput setaf 3)post-$(HOOK)$$(tput setaf 5) hook$$(tput sgr0)"; \
		$(SHELL) "./$@/hooks/post-$(HOOK)"; \
	fi
# -----------------------------------------------------------------------------
.PHONY: $(STOWABLE)
