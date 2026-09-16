CADDY := caddy

.PHONY: all check-fmt clean dev fmt spelling test

TYPOS_VERSION ?= 1.48.0
TYPOS := uv tool run typos@$(TYPOS_VERSION)

MDLINT ?= $(shell command -v markdownlint-cli2 2>/dev/null || printf '%s' "$$HOME/.bun/bin/markdownlint-cli2")
# `make fmt` and `make check-fmt` call mdtablefix directly. `--git` selects the
# Markdown files Git tracks and `--include-untracked` adds the untracked files
# Git does not ignore, so a new document is formatted before it is staged.
# Both modes need mdtablefix 0.6.0 or later; CI pins the version at the
# install-mdtablefix step.
MDTABLEFIX ?= mdtablefix
MDTABLEFIX_SELECT = --git --include-untracked
MDTABLEFIX_RULES = --wrap --renumber --breaks --ellipsis --fences

all: dev

dev:
	@echo "Serving on http://localhost:2018/"
	$(CADDY) file-server --listen localhost:2018

clean:
	@:

check-fmt: ## Verify Markdown formatting
	$(MDTABLEFIX) --check $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)

fmt:
	$(MDTABLEFIX) --in-place $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)
	$(MDLINT) --fix "**/*.md"

test:
	@:

spelling: ## Enforce en-GB-oxendict spelling in Markdown prose
	uv run scripts/generate_typos_config.py
	find . -type f -name '*.md' -print0 | \
		xargs -0 -r $(TYPOS) --config typos.toml --force-exclude
