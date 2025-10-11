# Phase 1: Command-Line Client

In this phase, you will:

* Implement an interactive SQL shell with readline support
* Build input handling for multiple input methods (interactive, file, pipe, arguments)
* Create beautiful table output formatting
* Implement command parsing and error handling

To copy the test cases and run them,

```
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation
```

## Task 1: Basic CLI Structure

In this task, you will need to create:

```
client/
├── main.{rs,cpp,py,go,java}     # Entry point
├── cli/                         # Interactive shell
├── formatter/                   # Output formatting
└── config/                      # Configuration
```

First, let's implement the basic command-line interface structure. Your client should support multiple input methods:

* **Interactive mode**: `./client` - starts an interactive SQL shell
* **File input**: `./client -f queries.sql` - executes SQL from file
* **Piped input**: `echo "SELECT * FROM users;" | ./client` - processes piped SQL
* **Direct command**: `./client "SELECT * FROM users;"` - executes single command

Start with a minimal implementation that can accept SQL commands and return mock responses. The goal is to establish the
interface patterns that will work with the testing framework.

Your `main` function should handle argument parsing and dispatch to the appropriate input mode. For Phase 1, you can
return hardcoded responses to establish the interface:

```sql
SELECT *
FROM users;
-- Should return formatted table with sample data
```

## Task 2: Interactive Shell Implementation

In this task, you will need to modify:

```
cli/shell.{rs,cpp,py,go,java}
```

Implement a full-featured interactive shell with the following capabilities:

* **Prompt**: Display a clear SQL prompt (e.g., `sql> `)
* **Multi-line input**: Handle SQL statements spanning multiple lines
* **Command history**: Store and recall previous commands with arrow keys
* **Auto-completion**: Tab completion for SQL keywords
* **Line editing**: Support for editing commands before execution

Use your language's readline library or equivalent:

* **Rust**: `rustyline` crate
* **C++**: `readline` library
* **Go**: `liner` library
* **Python**: `prompt_toolkit`
* **Java**: `JLine` library

The shell should loop continuously, accepting commands until the user types `exit`, `quit`, or presses Ctrl+D.

## Task 3: Output Formatting

In this task, you will need to modify:

```
formatter/table.{rs,cpp,py,go,java}
```

Implement beautiful table formatting for query results. Your formatter should:

* **Calculate column widths** automatically based on content
* **Align content** properly (left for strings, right for numbers)
* **Draw table borders** using Unicode box-drawing characters
* **Handle null values** gracefully
* **Support color coding** for different data types (optional)

Example output format:

```
┌────┬─────────┬─────┬─────────────────────┐
│ id │ name    │ age │ email               │
├────┼─────────┼─────┼─────────────────────┤
│ 1  │ Alice   │ 30  │ alice@example.com   │
│ 2  │ Bob     │ 25  │ bob@example.com     │
│ 3  │ Charlie │ 35  │ charlie@example.com │
└────┴─────────┴─────┴─────────────────────┘
3 rows returned (0.045s)
```

Your formatter should also support alternative output formats for testing:

* **JSON format**: For automated test validation
* **CSV format**: For data export
* **Tab-separated**: For scripting

## Task 4: Command-Line Arguments

In this task, you will need to modify:

```
main.{rs,cpp,py,go,java}
config/args.{rs,cpp,py,go,java}
```

Implement comprehensive command-line argument parsing:

```bash
./client --help                     # Show usage information
./client --version                  # Display version
./client --host localhost           # Set server host (for Phase 2)
./client --port 5432               # Set server port (for Phase 2)
./client --config client.conf      # Use config file
./client --format json             # Set output format
./client --no-color               # Disable colored output
./client --quiet                  # Suppress startup messages
```

Use your language's argument parsing library:

* **Rust**: `clap` crate
* **C++**: `CLI11` or `argparse`
* **Go**: `cobra` library
* **Python**: `click` or `argparse`
* **Java**: `picocli` library

## Task 5: Configuration Management

In this task, you will need to modify:

```
config/settings.{rs,cpp,py,go,java}
```

Support configuration from multiple sources (priority order):

1. Command-line arguments (highest)
2. Environment variables
3. Configuration file
4. Default values (lowest)

Example configuration file (`client.conf`):

```toml
[connection]
host = "localhost"
port = 5432
timeout = 30

[display]
format = "table"
color = true
max_width = 120
page_size = 50

[history]
file = "~/.client_history"
max_entries = 1000
```

The configuration should be loaded at startup and used throughout the application.

## Task 6: Error Handling

In this task, you will need to modify:

```
All modules with comprehensive error handling
```

Implement user-friendly error handling:

* **Syntax suggestions**: When user types invalid SQL, suggest corrections
* **Connection errors**: Clear messages when server is unreachable (for Phase 2)
* **Input validation**: Handle malformed commands gracefully
* **File errors**: Clear messages for missing or unreadable files

Example error output:

```
Error: Syntax error near 'SELCT'
  |
1 | SELCT * FROM users;
  |       ^
  |
Did you mean: SELECT?
```

## Testing Your Implementation

Run the Phase 1 tests to validate your implementation:

```bash
# Test all Phase 1 functionality
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation

# Test specific features
./tools/test-runner/run_tests.sh --phase 1 --test cli-interactive
./tools/test-runner/run_tests.sh --phase 1 --test output-formatting
./tools/test-runner/run_tests.sh --phase 1 --test argument-parsing
```

## Performance Requirements

Your client should meet these performance criteria:

* **Startup time**: < 500ms for responsive user experience
* **Command response**: < 100ms for UI interactions
* **Memory usage**: Efficient string handling and result buffering
* **Cross-platform**: Works on Linux, macOS, and Windows (WSL)

## Test Your Understanding

* Why do we support multiple input methods instead of just interactive mode?
* How does the table formatter handle columns of different widths efficiently?
* What are the trade-offs between different readline implementations?
* Why is configuration priority important in command-line tools?
* How do you ensure consistent behavior across different operating systems?
* What are the memory implications of storing command history?
* How would you implement auto-completion for table and column names?

## Bonus Tasks

* **Syntax highlighting**: Color SQL keywords in the interactive shell
* **Query timing**: Display execution time for each command
* **Result paging**: Handle large result sets with pagination
* **Export functionality**: Save results to various file formats
* **Keyboard shortcuts**: Implement common editor shortcuts (Ctrl+A, Ctrl+E, etc.)

## Language-Specific Tips

### Rust

```rust
// Use clap for argument parsing
use clap::{App, Arg, SubCommand};

// Use rustyline for interactive input
use rustyline::{Editor, Result};
use rustyline::error::ReadlineError;

// Use tabled for table formatting
use tabled::{Table, Tabled};
```

### C++

```cpp
// Use CLI11 for argument parsing
#include <CLI/CLI.hpp>

// Use readline for interactive input
#include <readline/readline.h>
#include <readline/history.h>

// Implement custom table formatting
```

### Go

```go
// Use cobra for CLI framework
import "github.com/spf13/cobra"

// Use liner for readline functionality
import "github.com/peterh/liner"

// Use tablewriter for table formatting
import "github.com/olekukonko/tablewriter"
```

### Python

```python
# Use click for CLI framework
import click

# Use prompt_toolkit for advanced input
from prompt_toolkit import prompt
from prompt_toolkit.history import InMemoryHistory

# Use tabulate for table formatting
from tabulate import tabulate
```

### Java

```java
// Use picocli for command-line interface

import picocli.CommandLine;

// Use JLine for readline functionality
import org.jline.reader.LineReader;
import org.jline.reader.LineReaderBuilder;

// Use ASCII Table for formatting
import de.vandermeer.asciitable.AsciiTable;
```

## Common Pitfalls

* **Terminal compatibility**: Test on different terminal emulators
* **Unicode handling**: Ensure proper Unicode support for table borders
* **Memory leaks**: Handle large result sets efficiently
* **Signal handling**: Graceful handling of Ctrl+C and other signals
* **Input validation**: Robust parsing of malformed input
* **Cross-platform paths**: Handle file paths correctly on different OS

Your Phase 1 client will serve as the primary interface for testing all subsequent phases, so invest time in making it
robust, user-friendly, and efficient!