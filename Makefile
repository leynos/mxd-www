CADDY := caddy

.PHONY: dev

dev:
	@echo "Serving on http://localhost:2018/"
	$(CADDY) file-server --browse --listen 127.0.0.1:2018

