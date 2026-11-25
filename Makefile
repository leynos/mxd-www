CADDY := caddy

# `make fmt` and `make check-fmt` call mdtablefix directly. `--git` selects the
# Markdown files Git tracks and `--include-untracked` adds the untracked files
# Git does not ignore, so a new document is formatted before it is staged.
# Both modes need mdtablefix 0.6.0 or later.
MDLINT ?= markdownlint-cli2
MDTABLEFIX ?= mdtablefix
MDTABLEFIX_SELECT = --git --include-untracked
MDTABLEFIX_RULES = --wrap --renumber --breaks --ellipsis --fences

.PHONY: all dev clean fmt spelling test check-fmt

TYPOS_CONFIG_BUILDER_VERSION ?= v0.1.4
TYPOS_CONFIG_BUILDER = uv tool run --python 3.14 --from \
	"git+https://github.com/leynos/typos-config-builder.git@$(TYPOS_CONFIG_BUILDER_VERSION)" \
	typos-config-builder

all: dev

dev:
	@echo "Serving on http://localhost:2018/"
	$(CADDY) file-server --listen localhost:2018

clean:
	@:

fmt:
	$(MDTABLEFIX) --in-place $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)
	$(MDLINT) --fix "**/*.md"

test:
	@:

# The gate reads tracked files only, so stage new Markdown files before running
# this target; untracked files are not checked.
spelling: ## Enforce en-GB-oxendict spelling in prose
	$(TYPOS_CONFIG_BUILDER) gate --repository .

check-fmt: ## Verify Markdown formatting
	$(MDTABLEFIX) --check $(MDTABLEFIX_SELECT) $(MDTABLEFIX_RULES)
