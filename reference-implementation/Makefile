# Centralized Makefile for Reference Implementation
# Supports building any phase/task with language detection

.PHONY: help build clean test list

# Default target shows help
help:
	@echo "📚 Reference Implementation Build System"
	@echo ""
	@echo "Usage:"
	@echo "  make build PATH=phase1/task2    # Build specific phase/task"
	@echo "  make clean PATH=phase1/task2    # Clean specific phase/task"
	@echo "  make test PATH=phase1/task2     # Test specific phase/task"
	@echo "  make list                       # List available implementations"
	@echo ""
	@echo "Examples:"
	@echo "  make build PATH=phase1/task2    # Build Phase 1 Task 2"
	@echo "  make build PATH=phase2/task1    # Build Phase 2 Task 1 (when available)"
	@echo ""
	@echo "The PATH parameter should point to a directory containing:"
	@echo "  - rust/     (Rust implementation)"
	@echo "  - python/   (Python implementation)"
	@echo "  - go/       (Go implementation)"
	@echo "  - java/     (Java implementation)"

# Build target - requires PATH parameter
build:
	@if [ -z "$(PATH_PARAM)" ]; then \
		echo "❌ Error: PATH parameter required"; \
		echo "Usage: make build PATH=phase1/task2"; \
		exit 1; \
	fi
	@if [ ! -d "$(PATH_PARAM)" ]; then \
		echo "❌ Error: Directory $(PATH_PARAM) not found"; \
		echo "Available implementations:"; \
		find . -name "rust" -o -name "python" -o -name "go" -o -name "java" | sed 's|/[^/]*$$||' | sort -u | sed 's|^./||'; \
		exit 1; \
	fi
	@echo "🔨 Building $(PATH_PARAM)..."
	@cd "$(PATH_PARAM)" && $(MAKE) -f ../../build-rules.mk build
	@echo "✅ Build complete for $(PATH_PARAM)"

# Clean target
clean:
	@if [ -z "$(PATH_PARAM)" ]; then \
		echo "❌ Error: PATH parameter required"; \
		echo "Usage: make clean PATH=phase1/task2"; \
		exit 1; \
	fi
	@if [ ! -d "$(PATH_PARAM)" ]; then \
		echo "❌ Error: Directory $(PATH_PARAM) not found"; \
		exit 1; \
	fi
	@echo "🧹 Cleaning $(PATH_PARAM)..."
	@cd "$(PATH_PARAM)" && $(MAKE) -f ../../build-rules.mk clean
	@echo "✅ Clean complete for $(PATH_PARAM)"

# Test target
test:
	@if [ -z "$(PATH_PARAM)" ]; then \
		echo "❌ Error: PATH parameter required"; \
		echo "Usage: make test PATH=phase1/task2"; \
		exit 1; \
	fi
	@if [ ! -d "$(PATH_PARAM)" ]; then \
		echo "❌ Error: Directory $(PATH_PARAM) not found"; \
		exit 1; \
	fi
	@echo "🧪 Testing $(PATH_PARAM)..."
	@cd "$(PATH_PARAM)" && $(MAKE) -f ../../build-rules.mk test
	@echo "✅ Test complete for $(PATH_PARAM)"

# List available implementations
list:
	@echo "📋 Available implementations:"
	@find . -name "rust" -o -name "python" -o -name "go" -o -name "java" | while read impl; do \
		dir=$$(dirname "$$impl"); \
		lang=$$(basename "$$impl"); \
		echo "  $$dir ($$lang)"; \
	done | sed 's|^./||' | sort -u

# Handle PATH parameter (make converts PATH to PATH_PARAM to avoid conflicts)
ifdef PATH
PATH_PARAM := $(PATH)
endif