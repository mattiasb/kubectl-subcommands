################################################################################
## Makefile config

SHELL       := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:
.SILENT:
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rules
NULL        :=

################################################################################
## Macros

define show
	echo "## $1" ;                                \
	{ $(foreach v,$2,echo $(v)=$($(v));) }        \
	| column -tL -o ' = ' -s '=' --table-right 1; \
	echo
endef

################################################################################
## XDG constants

XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_STATE_HOME  ?= $(HOME)/.local/state
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME  ?= $(HOME)/.cache

################################################################################
## GNU standard installation directories

# See https://www.gnu.org/prep/standards/html_node/Directory-Variables.html

ifeq ($(shell id -u), 0)
	prefix     ?= /usr/local
	sysconfdir ?= /etc/kubectl-subcommands
else
	prefix     ?= $(shell realpath -m $(XDG_DATA_HOME)/..)
	sysconfdir ?= $(XDG_CONFIG_HOME)/kubectl-subcommands
endif
datarootdir        ?= $(prefix)/share/kubectl-subcommands
bindir             ?= $(prefix)/bin

################################################################################
## Other constants

os-run-deps = $(addprefix /usr/bin/, fzf getopt jq kubectl)
os-dev-deps = $(addprefix /usr/bin/, git shellcheck)
os-deps     = $(os-dev-deps) $(os-run-deps)

libs        = $(notdir $(wildcard src/lib.*))
bins        = $(filter-out $(libs), $(notdir $(wildcard src/*)))
comps       = kubectl-context kubectl-namespace kubectl-secret

targets     = $(addprefix $(datarootdir)/, $(libs)) \
              $(addprefix $(bindir)/,      $(bins)) \
              $(addprefix $(bindir)/kubectl_complete-, $(comps:kubectl-%=%))

xdg-vars    = XDG_DATA_HOME XDG_STATE_HOME XDG_CONFIG_HOME XDG_CACHE_HOME
gnu-vars    = prefix datarootdir bindir sysconfdir
src-vars    = libs bins comps
dst-vars    = libs bins comps
dep-vars    = os-dev-deps os-run-deps

################################################################################

.PHONY: all check debug install uninstall

all:

debug:
	$(call show, XDG,  $(xdg-vars))
	$(call show, GNU,  $(gnu-vars))
	$(call show, src,  $(src-vars))
	$(call show, dst,  targets)
	$(call show, deps, $(dep-vars))

check: $(os-dev-deps)
	shellcheck src/*

install: $(os-run-deps) $(targets)

uninstall:
	$(foreach t,$(targets), rm $(t) ||:;)

################################################################################

$(bindir)/kubectl-%: src/kubectl-%
	echo -e "$(<) =⇒ $(@)"
	install -m '0755' -DT $(<) $(@)

$(bindir)/kubectl_complete-%: $(bindir)/kubectl-%
	echo -e "$(@) —→ $(<)"
	ln -s  $(<) $(@)

$(datarootdir)/%: src/%
	echo -e "$(<) ⇒ $(@)"
	install -m '0644' -DT $(<) $(@)

$(os-run-deps):
	aux/bin/check-commands $(notdir $(os-run-deps))

$(os-dev-deps):
	aux/bin/check-commands $(notdir $(os-dev-deps))
