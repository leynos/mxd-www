CADDY := caddy

.PHONY: all dev clean test

all: dev

dev:
	@echo "Serving on http://localhost:2018/"
	$(CADDY) file-server --listen localhost:2018

clean:
	@:

test:
	@:

