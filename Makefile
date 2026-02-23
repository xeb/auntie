.PHONY: help build release install clean test binary-size

# Colors
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RESET := \033[0m

help: ## Show this help menu
	@echo ""
	@echo "$(CYAN)auntie$(RESET) - Chrome browser automation CLI"
	@echo ""
	@echo "$(YELLOW)Usage:$(RESET)"
	@echo "  make $(GREEN)<target>$(RESET)"
	@echo ""
	@echo "$(YELLOW)Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""

build: ## Build in debug mode
	cargo build

release: ## Build in release mode (optimized)
	cargo build --release

install: ## Install globally via cargo
	cargo install --path .

clean: ## Clean build artifacts
	cargo clean

test: ## Run tests
	cargo test

binary-size: release ## Show release binary size
	@size=$$(ls -lh target/release/auntie | awk '{print $$5}'); \
	echo "$(GREEN)auntie binary size: $$size$(RESET)"
