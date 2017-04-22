SHELL := /bin/bash
STOW_TARGET = $$HOME

ACTION = stow
# Bash completions seems to handle this fine, but not zsh :/
STOWABLE = $(shell echo */ | sed 's;/;;g')

# if the *first* argument is 'unstow,'
ifeq (unstow, $(firstword $(MAKECMDGOALS)))
# then set variables accordingly
unstow:
	@echo "$$(tput setaf 3)Setting: $$(tput setaf 5)STOW_OPTIONS = -D, ACTION = unstow$$(tput sgr0)"
	$(eval STOW_OPTIONS = -D)
	$(eval ACTION = unstow)
else ifeq (restow, $(firstword $(MAKECMDGOALS)))
restow:
	make unstow $(filter-out $@, $(MAKECMDGOALS))
	make        $(filter-out $@, $(MAKECMDGOALS))
endif

stow-all: ACTION = stow
stow-all: STOW_OPTIONS =
stow-all: $(STOWABLE)

unstow-all: ACTION = unstow
unstow-all: STOW_OPTIONS = -D
unstow-all: $(STOWABLE)

# Stow has -R option, but use this, to trigger *-unstow and *-stow hooks
restow-all: unstow-all
	make stow-all

$(STOWABLE):
	@echo "$$(tput setaf 3)Processing: $$(tput setaf 5)$@$$(tput sgr0)"
	@if [[ -x "$@/hooks/pre-$(ACTION)" ]]; then \
		echo "$$(tput setaf 5)  Running $$(tput setaf 3)pre-$(ACTION)$$(tput setaf 5) hook$$(tput sgr0)"; \
		$(SHELL) "./$@/hooks/pre-$(ACTION)"; \
	fi
	@stow -v -t "$(STOW_TARGET)" \
		--no-folding \
		--ignore='^README.md$$' \
		--ignore='^hooks$$' \
 		$(STOW_OPTIONS) $@
	@if [[ -x "$@/hooks/post-$(ACTION)" ]]; then \
		echo "$$(tput setaf 5)  Running $$(tput setaf 3)post-$(ACTION)$$(tput setaf 5) hook$$(tput sgr0)"; \
		$(SHELL) "./$@/hooks/post-$(ACTION)"; \
	fi

.PHONY: $(STOWABLE)
