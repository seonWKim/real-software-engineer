# Shared build rules for all phases and tasks
# This file contains the actual build logic for different languages

# Use bash shell for better command support and preserve PATH
SHELL := /bin/bash
PATH := $(PATH)

.PHONY: build clean test detect-language

# Auto-detect available language and build
build: detect-language
	@if [ -d "rust" ] && [ -f "rust/Cargo.toml" ]; then \
		echo "🦀 Building Rust implementation..."; \
		CARGO_CMD=""; \
		if command -v cargo >/dev/null 2>&1; then \
			CARGO_CMD="cargo"; \
		elif [ -f "$$HOME/.cargo/bin/cargo" ]; then \
			CARGO_CMD="$$HOME/.cargo/bin/cargo"; \
		elif [ -f "/usr/local/bin/cargo" ]; then \
			CARGO_CMD="/usr/local/bin/cargo"; \
		fi; \
		if [ -n "$$CARGO_CMD" ]; then \
			(cd rust && $$CARGO_CMD build --release) && \
			/bin/cp rust/target/release/client ./client && \
			/bin/chmod +x ./client && \
			echo "✅ Rust implementation built successfully"; \
		else \
			echo "❌ cargo command not found. Please install Rust."; \
			echo "Looked in: PATH, ~/.cargo/bin/cargo, /usr/local/bin/cargo"; \
			exit 1; \
		fi; \
	elif [ -d "python" ] && [ -f "python/main.py" ]; then \
		echo "🐍 Setting up Python implementation..."; \
		/bin/cp python/main.py ./client && \
		/bin/chmod +x ./client && \
		echo "✅ Python implementation set up successfully"; \
	elif [ -d "go" ] && [ -f "go/main.go" ]; then \
		echo "🐹 Building Go implementation..."; \
		if command -v go >/dev/null 2>&1; then \
			(cd go && go build -o ../client main.go) && \
			/bin/chmod +x ./client && \
			echo "✅ Go implementation built successfully"; \
		else \
			echo "❌ go command not found. Please install Go."; \
			exit 1; \
		fi; \
	elif [ -d "java" ] && [ -f "java/Main.java" ]; then \
		echo "☕ Building Java implementation..."; \
		if command -v javac >/dev/null 2>&1; then \
			(cd java && javac Main.java) && \
			echo '#!/bin/bash' > ./client && \
			echo 'java -cp "$$(dirname "$$0")/java" Main "$$@"' >> ./client && \
			/bin/chmod +x ./client && \
			echo "✅ Java implementation built successfully"; \
		else \
			echo "❌ javac command not found. Please install Java."; \
			exit 1; \
		fi; \
	else \
		echo "❌ No recognized implementation found in current directory"; \
		echo "Expected one of:"; \
		echo "  - rust/Cargo.toml (Rust)"; \
		echo "  - python/main.py (Python)"; \
		echo "  - go/main.go (Go)"; \
		echo "  - java/Main.java (Java)"; \
		exit 1; \
	fi

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -f ./client
	@if [ -d "rust" ]; then cd rust && cargo clean 2>/dev/null || true; fi
	@if [ -d "go" ]; then cd go && go clean 2>/dev/null || true; fi
	@if [ -d "java" ]; then cd java && rm -f *.class 2>/dev/null || true; fi
	@echo "✅ Clean complete"

# Test the built client
test:
	@echo "🧪 Testing client..."
	@if [ -x ./client ]; then \
		echo "Client executable found, running basic test..."; \
		echo "exit" | ./client || echo "Test completed"; \
	else \
		echo "❌ Client executable not found. Run build first."; \
		exit 1; \
	fi

# Detect and report available languages
detect-language:
	@echo "🔍 Detecting available implementations..."
	@if [ -d "rust" ]; then echo "  ✅ Rust (rust/)"; fi
	@if [ -d "python" ]; then echo "  ✅ Python (python/)"; fi
	@if [ -d "go" ]; then echo "  ✅ Go (go/)"; fi
	@if [ -d "java" ]; then echo "  ✅ Java (java/)"; fi