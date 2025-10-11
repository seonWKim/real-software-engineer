# Task 1: Basic CLI Structure

In this task, you will:

* Create the foundation for your command-line client
* Establish basic SQL command recognition
* Set up mock response handling for testing

To copy the test cases and run them,

```
./tools/test-runner/run_tests.sh --phase 1 --task 1 --implementation student-submissions/my-implementation
```

## Implementation Overview

In this task, you will need to create:

<div class="file-tree">
client/
├── main.{rs,cpp,py,go,java}     # Entry point
├── cli/
│   └── shell.{rs,cpp,py,go,java}  # Basic shell structure
├── formatter/
│   └── mock.{rs,cpp,py,go,java}   # Mock response formatter
└── config/
    └── args.{rs,cpp,py,go,java}   # Basic argument parsing
</div>

## Step 1: Entry Point and Input Methods

First, implement the main entry point that can handle multiple input methods:

### Interactive Mode

```bash
./client
sql> SELECT * FROM users;
# Should display formatted mock data
sql> exit
```

### File Input

```bash
./client -f queries.sql
# Should execute all SQL statements in the file
```

### Piped Input

```bash
echo "SELECT * FROM users;" | ./client
# Should process the piped SQL and output results
```

### Direct Command

```bash
./client "SELECT * FROM users;"
# Should execute the command and output results immediately
```

Your main function should:

1. Parse command-line arguments to determine input method
2. Initialize the appropriate input handler
3. Process SQL commands and return mock responses
4. Handle graceful shutdown

## Step 2: Raw SQL Command Handling

For Phase 1, the client treats SQL as opaque strings. No parsing is required - just basic validation and preparation for
network transmission:

```rust
// Example command handling (adapt to your language)
struct SqlCommand {
    raw_sql: String,
    timestamp: SystemTime,
}

fn prepare_command(input: &str) -> Result<SqlCommand, ClientError> {
    let trimmed = input.trim();

    // Basic validation - just check if it's not empty
    if trimmed.is_empty() {
        return Err(ClientError::EmptyCommand);
    }

    // Handle special client commands (not SQL)
    if trimmed.eq_ignore_ascii_case("exit") || trimmed.eq_ignore_ascii_case("quit") {
        return Err(ClientError::ExitRequested);
    }

    Ok(SqlCommand {
        raw_sql: trimmed.to_string(),
        timestamp: SystemTime::now(),
    })
}
```

## Step 3: Mock Response Generation

Create mock responses for different SQL commands to establish the interface:

### Sample Data

```rust
// Example mock data structure
struct MockTable {
    columns: Vec<String>,
    rows: Vec<Vec<String>>,
}

fn create_mock_users_table() -> MockTable {
    MockTable {
        columns: vec!["id".to_string(), "name".to_string(), "age".to_string(), "email".to_string()],
        rows: vec![
            vec!["1".to_string(), "Alice".to_string(), "30".to_string(), "alice@example.com".to_string()],
            vec!["2".to_string(), "Bob".to_string(), "25".to_string(), "bob@example.com".to_string()],
            vec!["3".to_string(), "Charlie".to_string(), "35".to_string(), "charlie@example.com".to_string()],
        ],
    }
}
```

### Response Generation

```rust
fn generate_mock_response(command: &SqlCommand) -> MockTable {
    let sql_upper = command.raw_sql.to_uppercase();

    // Simple keyword detection for mock responses (no real parsing)
    if sql_upper.contains("SELECT") {
        // Return mock table data
        create_mock_users_table()
    } else if sql_upper.contains("INSERT") {
        // Return success message
        MockTable {
            columns: vec!["result".to_string()],
            rows: vec![vec!["1 row inserted".to_string()]],
        }
    } else if sql_upper.contains("CREATE") {
        MockTable {
            columns: vec!["result".to_string()],
            rows: vec![vec!["Table created successfully".to_string()]],
        }
    } else {
        // Default response for any SQL
        MockTable {
            columns: vec!["message".to_string()],
            rows: vec![vec![format!("Mock response for: {}", command.raw_sql)]],
        }
    }
}
```

## Step 4: Basic Output Formatting

Implement simple table formatting for the mock responses:

```
┌────┬─────────┬─────┬─────────────────────┐
│ id │ name    │ age │ email               │
├────┼─────────┼─────┼─────────────────────┤
│ 1  │ Alice   │ 30  │ alice@example.com   │
│ 2  │ Bob     │ 25  │ bob@example.com     │
│ 3  │ Charlie │ 35  │ charlie@example.com │
└────┴─────────┴─────┴─────────────────────┘
3 rows returned (0.001s)
```

Key formatting requirements:

- Automatic column width calculation
- Unicode box-drawing characters
- Proper alignment (left for strings, right for numbers)
- Row count and timing information

## Step 5: Command-Line Argument Parsing

Implement basic argument parsing to support the different input methods:

```bash
./client --help                     # Show usage information
./client --version                  # Display version
./client -f queries.sql             # File input
./client "SELECT * FROM users;"     # Direct command
./client                            # Interactive mode (default)
```

### Example Implementation Structure

#### Rust with clap

```rust
use clap::{App, Arg, ArgMatches};

fn parse_args() -> ArgMatches {
    App::new("Database Client")
        .version("1.0.0")
        .about("Interactive SQL client for the Real Engineer Database")
        .arg(Arg::new("file")
            .short('f')
            .long("file")
            .value_name("FILE")
            .help("Execute SQL commands from file"))
        .arg(Arg::new("command")
            .help("SQL command to execute")
            .index(1))
        .get_matches()
}
```

#### C++ with CLI11

```cpp
#include <CLI/CLI.hpp>

struct Config {
    std::string file;
    std::string command;
    bool interactive = true;
};

Config parse_args(int argc, char** argv) {
    CLI::App app{"Database Client"};
    Config config;
    
    app.add_option("-f,--file", config.file, "Execute SQL commands from file");
    app.add_option("command", config.command, "SQL command to execute");
    
    CLI11_PARSE(app, argc, argv);
    
    if (!config.file.empty() || !config.command.empty()) {
        config.interactive = false;
    }
    
    return config;
}
```

## Step 6: Error Handling

Implement basic error handling for common scenarios:

```rust
enum ClientError {
    FileNotFound(String),
    InvalidSql(String),
    IoError(String),
}

fn handle_error(error: ClientError) {
    match error {
        ClientError::FileNotFound(filename) => {
            eprintln!("Error: File '{}' not found", filename);
            eprintln!("Please check the file path and try again.");
        }
        ClientError::InvalidSql(sql) => {
            eprintln!("Error: Invalid SQL command");
            eprintln!("  {}", sql);
            eprintln!("Please check your SQL syntax.");
        }
        ClientError::IoError(msg) => {
            eprintln!("Error: I/O operation failed: {}", msg);
        }
    }
}
```

## Testing Your Implementation

Test each input method to ensure they work correctly:

### Test Interactive Mode

```bash
./client
sql> SELECT * FROM users;
# Should display formatted table
sql> CREATE TABLE test (id INTEGER, name VARCHAR(50));
# Should show success message
sql> exit
```

### Test File Input

Create a test file:

```sql
-- test.sql
SELECT *
FROM users;
CREATE TABLE products
(
    id    INTEGER,
    name  VARCHAR(100),
    price DECIMAL(10, 2)
);
INSERT INTO products
VALUES (1, 'Laptop', 999.99);
```

```bash
./client -f test.sql
# Should execute all commands and show results
```

### Test Piped Input

```bash
echo "SELECT * FROM users;" | ./client
# Should process and display results
```

### Test Direct Command

```bash
./client "SELECT * FROM users WHERE age > 25;"
# Should execute and display results immediately
```

## Performance Requirements

Your basic client should meet these criteria:

- **Startup time**: < 500ms
- **Command processing**: < 100ms for mock responses
- **Memory usage**: < 20MB for basic operations

## Language-Specific Tips

### Rust

```rust
// Use clap for arguments, std::io for input handling
use clap::App;
use std::io::{self, BufRead, BufReader};
use std::fs::File;

// Handle different input sources uniformly
enum InputSource {
    Stdin(io::Stdin),
    File(BufReader<File>),
    Command(std::iter::Once<String>),
}
```

### C++

```cpp
// Use CLI11 for arguments, iostream for input
#include <CLI/CLI.hpp>
#include <iostream>
#include <fstream>
#include <sstream>

// Abstract input handling
class InputHandler {
public:
    virtual std::string get_next_command() = 0;
    virtual bool has_more() = 0;
};
```

### Go

```go
// Use cobra for CLI, bufio for input handling
import (
    "bufio"
    "os"
    "strings"
    "github.com/spf13/cobra"
)

type InputReader interface {
    ReadLine() (string, error)
}
```

### Python

```python
# Use click for CLI, sys for input handling
import click
import sys
from typing import Iterator

def get_input_source(file_path: str = None, command: str = None) -> Iterator[str]:
    if command:
        yield command
    elif file_path:
        with open(file_path, 'r') as f:
            for line in f:
                if line.strip():
                    yield line.strip()
    else:
        # Interactive mode
        while True:
            try:
                line = input("sql> ")
                if line.strip():
                    yield line.strip()
            except EOFError:
                break
```

### Java

```java
// Use picocli for CLI, Scanner for input

import picocli.CommandLine;

import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

public class InputHandler {
    private Scanner scanner;

    public InputHandler(String source) throws FileNotFoundException {
        if (source == null) {
            scanner = new Scanner(System.in);
        } else {
            scanner = new Scanner(new File(source));
        }
    }
}
```

## Common Pitfalls

<div class="warning-box">
<h4>⚠️ Watch Out For</h4>

- **Input Buffering**: Ensure proper handling of different input sources
- **Signal Handling**: Handle Ctrl+C gracefully in interactive mode
- **File Encoding**: Support UTF-8 input files correctly
- **Empty Commands**: Handle empty lines and whitespace-only input
- **Resource Cleanup**: Close files and clean up resources properly

</div>

## Test Your Understanding

* Why do we support multiple input methods instead of just interactive mode?
* How does argument parsing help establish the client's interface?
* What are the benefits of starting with mock responses?
* How would you extend the command recognition to handle more complex SQL?
* What considerations are important for cross-platform compatibility?

## Next Steps

Once Task 1 is complete:

1. **Validate** with the test runner to ensure all basic functionality works
2. **Test** each input method thoroughly
3. **Document** your command recognition and response generation logic
4. **Prepare** for Task 2: Interactive Shell Implementation

Your basic CLI structure will serve as the foundation for all subsequent client enhancements!