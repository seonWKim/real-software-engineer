# Phase 1 Task 2: Interactive Shell - Reference Implementation

This directory contains reference implementations for the interactive shell task in multiple programming languages.

## Directory Structure

```
reference-implementation/phase1/task2/
├── client                    # Final executable (built from source)
├── rust/                     # Rust implementation
│   ├── src/main.rs
│   └── Cargo.toml
├── python/                   # Python implementation (future)
├── go/                       # Go implementation (future)  
├── java/                     # Java implementation (future)
└── README.md                 # This file
```

## Building

### Using centralized Make system (recommended)
```bash
# From reference-implementation root
make build PATH=phase1/task2

# Clean build artifacts
make clean PATH=phase1/task2

# Test the built client
make test PATH=phase1/task2

# List all available implementations
make list

# Show help
make help
```

## Adding New Language Implementations

1. Create a new directory for the language (e.g., `python/`, `go/`)
2. Implement the interactive shell following the same behavior
3. The centralized build system will automatically detect and build it
4. Ensure the final executable can be built to `./client`

This design ensures maximum flexibility while maintaining consistent testing and deployment.