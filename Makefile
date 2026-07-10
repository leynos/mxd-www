CADDY := caddy

.PHONY: all dev clean spelling test

TYPOS_VERSION ?= 1.48.0
TYPOS := uv tool run typos@$(TYPOS_VERSION)

all: dev

dev:
	@echo "Serving on http://localhost:2018/"
	$(CADDY) file-server --listen localhost:2018

clean:
	@:

test:
	@:

spelling: ## Enforce en-GB-oxendict spelling in Markdown prose
	uv run scripts/generate_typos_config.py
	find . -type f -name '*.md' -print0 | \
		xargs -0 -r $(TYPOS) --config typos.toml --force-exclude
