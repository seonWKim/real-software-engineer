# Phase 1 Task 2: Interactive Shell Implementation Tests (Simplified)

This directory contains simplified test suites for validating the basic interactive shell functionality of your database
client implementation **without requiring third-party libraries**.

## Overview

The interactive shell focuses on core functionality using only standard library features:

- Interactive SQL command execution with basic prompts (`sql>`)
- Simple terminal input/output handling
- Basic SQL command processing
- Exit/quit command handling
- Basic signal handling and process cleanup
- **No readline, clap, or other 3rd party dependencies required**

## Test Structure (Simplified)

```
test-suite/phase-1/task-2/
├── README.md                     # This documentation
├── run_all_tests.sh              # Simplified test runner (recommended)
├── test_basic_interactive.sh     # Basic interactive functionality
├── test_input_handling.sh        # Input handling tests
└── test_basic_signals.sh         # Basic signal handling tests
```

## Test Categories (Simplified)

### 1. Basic Interactive Functionality (`test_basic_interactive.sh`)

Tests core interactive shell features using simple I/O:

- Interactive prompt display (`sql>`)
- SQL command execution and mock responses
- Multiple commands in sequence
- Empty line handling
- Exit/quit commands (case insensitive)
- Basic error handling

### 2. Input Handling (`test_input_handling.sh`)

Tests various SQL input scenarios:

- Multi-line SQL statements (basic)
- Long SQL commands
- SQL with quoted strings
- SQL with special characters and numbers
- Whitespace handling in commands
- SQL comments (if supported)
- Case insensitive SQL keywords
- Rapid command sequences

### 3. Basic Signal Handling (`test_basic_signals.sh`)

Tests fundamental signal handling:

- EOF (Ctrl+D simulation) handling
- SIGTERM signal handling
- Process cleanup on exit
- Graceful shutdown behavior
- Broken pipe handling
- Resource cleanup verification

## Prerequisites (Simplified)

### Required Tools

- `bash` - shell environment (standard on Unix systems)
- `timeout` - for test timeout management (usually pre-installed)
- **No expect or third-party tools required!**

### Installation

Usually no additional installation needed - these tests use standard Unix tools.

### Client Implementation

Ensure your client executable is built and located at:

```
student-submissions/my-implementation/client
```

## Running Tests (Simplified)

### Run All Tests

```bash
# From project root - recommended approach
./test-suite/phase-1/task-2/run_all_tests.sh

# With custom implementation path
./test-suite/phase-1/task-2/run_all_tests.sh --implementation my-custom-path
```

### Run Specific Test Categories

```bash
# Basic interactive functionality only
./test-suite/phase-1/task-2/run_all_tests.sh --test basic

# Input handling only
./test-suite/phase-1/task-2/run_all_tests.sh --test input

# Basic signal handling only
./test-suite/phase-1/task-2/run_all_tests.sh --test signals
```

### Run Individual Test Scripts

```bash
# Set implementation directory
export IMPLEMENTATION_DIR="student-submissions/my-implementation"

# Run individual test scripts
./test-suite/phase-1/task-2/test_basic_interactive.sh
./test-suite/phase-1/task-2/test_input_handling.sh
./test-suite/phase-1/task-2/test_basic_signals.sh
```

### Command Line Options

```bash
./test-suite/phase-1/task-2/run_all_tests.sh [OPTIONS]

Options:
  -h, --help              Show help message
  -v, --verbose           Verbose output
  -q, --quiet             Quiet mode
  --implementation DIR    Implementation path
  --test NAME             Run specific test (basic|input|signals)
```

## Test Results Interpretation

### Exit Codes

- `0` - All tests passed or acceptable implementation level
- `1` - Test failures that need to be addressed

### Test Status Types

- **PASS** ✅ - Feature implemented correctly
- **FAIL** ❌ - Feature has issues that need fixing
- **SKIP** ⚠️ - Feature not yet implemented (acceptable for some advanced features)

### Understanding Results

#### Core Requirements (Must Pass)

These features are essential for Task 2:

- Basic interactive prompt display (`sql>`)
- SQL command execution with mock responses
- Exit/quit command handling
- Basic input/output handling
- Process cleanup on termination

#### Advanced Features (Optional)

These features are beneficial but not strictly required:

- Sophisticated multi-line SQL handling
- Advanced signal handling beyond EOF
- Complex input validation
- Performance optimizations

## Implementation Guidelines (Simplified)

### Language-Specific Standard Libraries Only

#### Rust

```rust
use std::io::{self, Write, BufRead};
// No external dependencies needed!
// Use std::io for input/output
// Use std::process for signal handling
```

#### C++

```cpp
#include <iostream>
#include <string>
#include <signal.h>
// Standard library only!
// Use std::cin/cout for I/O
// Use signal() for basic signal handling
```

#### Go

```go
import (
    "bufio"
    "fmt"
    "os"
    "os/signal"
    "syscall"
)
// Standard library only!
// Use bufio.Scanner for input
// Use os/signal for signal handling
```

#### Python

```python
import sys
import signal
# Standard library only!
# Use input() or sys.stdin for input
# Use signal module for signal handling
```

#### Java

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Scanner;
// Standard library only!
// Use Scanner or BufferedReader for input
// Use Runtime.addShutdownHook() for cleanup
```

### Key Implementation Points (Simplified)

1. **Basic I/O**: Use standard input/output for terminal interaction
2. **Simple Prompts**: Display `sql>` prompt before each command
3. **Command Processing**: Read lines, process SQL commands, show mock responses
4. **Exit Handling**: Recognize "exit" and "quit" commands (case insensitive)
5. **Signal Handling**: Handle EOF and basic signals for clean shutdown
6. **No Dependencies**: Avoid third-party libraries for maximum compatibility

## Troubleshooting

### Common Issues

#### 1. Tests Hanging

- **Cause**: Client not responding to input
- **Solution**: Check that client displays prompt and accepts input properly

#### 2. Signal Tests Failing

- **Cause**: Signals not handled properly
- **Solution**: Implement signal handlers for SIGINT and EOF

#### 3. History Tests Failing

- **Cause**: Arrow keys not working
- **Solution**: Use proper readline library integration

#### 4. expect Command Not Found

- **Cause**: expect not installed
- **Solution**: Install expect using package manager

#### 5. Client Executable Not Found

- **Cause**: Client not built or wrong path
- **Solution**: Build client and verify path

### Debug Mode

```bash
# Run with verbose output
./test-suite/phase-1/task-2/run_all_tests.sh --verbose

# Run individual test with debugging
bash -x ./test-suite/phase-1/task-2/test_interactive_basic.sh
```

### Test Environment Issues

- Ensure terminal supports ANSI escape sequences
- Test in a standard terminal emulator
- Verify expect version compatibility

## Success Criteria

### Minimum Requirements

- ✅ Interactive prompt display
- ✅ Command execution and mock responses
- ✅ Exit command handling
- ✅ Basic signal handling (Ctrl+C, Ctrl+D)

### Full Implementation

- ✅ Command history with arrow keys
- ✅ Line editing capabilities
- ✅ Multi-line SQL support
- ✅ Auto-completion features
- ✅ Robust signal handling

## Integration with Main Test Runner

These tests integrate with the main project test runner:

```bash
# Run via main test runner
./tools/test-runner/run_tests.sh --phase 1 --task 2 --implementation student-submissions/my-implementation
```

## Next Steps

After passing these tests:

1. Review any failed tests and implement missing features
2. Ensure core interactive functionality is solid
3. Proceed to **Task 3: Output Formatting**
4. Continue building the complete client functionality

Your interactive shell implementation forms the foundation for user interaction with your database system throughout all
subsequent phases.