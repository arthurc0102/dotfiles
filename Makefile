SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := help
help: Makefile
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help

brew-dump:  ## Dump brew packages to Brewfile
	brew bundle dump -f --file=Brewfile --no-vscode --no-go --no-cargo
.PHONY: brew-dump

brew-install:  ## Install brew packages from Brewfile
	brew bundle install --file=Brewfile
.PHONY: brew-install
