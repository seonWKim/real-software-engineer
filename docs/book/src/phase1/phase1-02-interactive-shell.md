# Task 2: Interactive Shell Implementation

## Overview

In this task, you'll implement a basic interactive SQL shell that accepts commands from standard input and provides
responses through standard output. The focus is on creating a simple, cross-language compatible implementation that uses
only standard library features.

**Key Design Principle**: This implementation deliberately avoids third-party libraries like `readline`, `clap`, or
similar tools to ensure maximum cross-language compatibility. Students can implement this task in any programming
language using only standard library features.

## Learning Objectives

- Standard input/output handling for interactive applications
- Command parsing and processing loop design
- Basic signal handling for graceful shutdown
- Cross-platform terminal interaction patterns
- SQL command recognition and mock response generation

## Requirements

### Core Functionality

Your interactive shell must implement:

1. **Interactive Prompt Display**
    - Display `sql>` prompt before each command
    - Handle both single-line and multi-line input gracefully

2. **SQL Command Processing**
    - Accept SQL commands from standard input
    - Process common SQL statements (SELECT, INSERT, CREATE, etc.)
    - Provide mock responses for demonstration purposes
    - Handle commands with or without semicolons

3. **Exit Command Handling**
    - Recognize `exit` and `quit` commands (case insensitive)
    - Clean shutdown when exit commands are received

4. **Basic Signal Handling**
    - Handle EOF (Ctrl+D) gracefully
    - Respond appropriately to SIGTERM signals
    - Ensure proper resource cleanup on termination

5. **Input Validation**
    - Handle empty lines gracefully
    - Process SQL with various formatting (quotes, special characters)
    - Manage rapid command sequences

## Implementation Guide

### Language-Specific Standard Library Examples

#### Rust

```rust
use std::io::{self, Write, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut stdout = io::stdout();

    loop {
        print!("sql> ");
        stdout.flush().unwrap();

        let mut input = String::new();
        match stdin.read_line(&mut input) {
            Ok(0) => break, // EOF
            Ok(_) => {
                let command = input.trim();
                if command.to_lowercase() == "exit" || command.to_lowercase() == "quit" {
                    break;
                }
                process_sql_command(command);
            }
            Err(_) => break,
        }
    }
}
```

#### C++

```cpp
#include <iostream>
#include <string>
#include <algorithm>
#include <signal.h>

void signal_handler(int signal) {
    std::cout << "\nShutting down gracefully...\n";
    exit(0);
}

int main() {
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    std::string input;
    while (true) {
        std::cout << "sql> ";
        if (!std::getline(std::cin, input)) {
            break; // EOF
        }
        
        std::transform(input.begin(), input.end(), input.begin(), ::tolower);
        if (input == "exit" || input == "quit") {
            break;
        }
        
        process_sql_command(input);
    }
    return 0;
}
```

#### Go

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "os/signal"
    "strings"
    "syscall"
)

func main() {
    // Handle signals
    c := make(chan os.Signal, 1)
    signal.Notify(c, os.Interrupt, syscall.SIGTERM)
    go func() {
        <-c
        fmt.Println("\nShutting down gracefully...")
        os.Exit(0)
    }()
    
    scanner := bufio.NewScanner(os.Stdin)
    
    for {
        fmt.Print("sql> ")
        if !scanner.Scan() {
            break // EOF
        }
        
        input := strings.TrimSpace(scanner.Text())
        if strings.ToLower(input) == "exit" || strings.ToLower(input) == "quit" {
            break
        }
        
        processSQLCommand(input)
    }
}
```

#### Python

```python
import sys
import signal

def signal_handler(sig, frame):
    print('\nShutting down gracefully...')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

def main():
    while True:
        try:
            command = input("sql> ").strip()
            if command.lower() in ['exit', 'quit']:
                break
            process_sql_command(command)
        except EOFError:
            break
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()
```

#### Java

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class SQLClient {
    public static void main(String[] args) {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            System.out.println("\nShutting down gracefully...");
        }));

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        try {
            while (true) {
                System.out.print("sql> ");
                String input = reader.readLine();

                if (input == null) { // EOF
                    break;
                }

                input = input.trim();
                if (input.equalsIgnoreCase("exit") || input.equalsIgnoreCase("quit")) {
                    break;
                }

                processSQLCommand(input);
            }
        } catch (IOException e) {
            System.err.println("Error reading input: " + e.getMessage());
        }
    }
}
```

### Implementation Tips

1. **Keep It Simple**: Use only standard library I/O functions
2. **Handle Edge Cases**: Empty input, whitespace, case sensitivity
3. **Mock Responses**: Provide simple, consistent responses for SQL commands
4. **Cross-Platform**: Avoid platform-specific terminal libraries
5. **Error Handling**: Gracefully handle I/O errors and signals

### Mock Response Examples

For demonstration purposes, implement simple mock responses:

```
sql> SELECT * FROM users;
| id | name  | age | email           |
|----|-------|-----|-----------------|
| 1  | Alice | 30  | alice@email.com |
| 2  | Bob   | 25  | bob@email.com   |
2 rows returned.

sql> CREATE TABLE test (id INTEGER);
Table 'test' created successfully.

sql> INSERT INTO users VALUES (3, 'Charlie', 35, 'charlie@email.com');
1 row inserted.

sql> exit
Goodbye!
```

## Testing

Your implementation will be tested using a simplified test suite that validates core functionality without requiring
third-party dependencies.

### Test Categories

1. **Basic Interactive Functionality** (`test_basic_interactive.sh`)
    - Interactive prompt display (`sql>`)
    - SQL command execution with mock responses
    - Multiple commands in sequence
    - Empty line handling
    - Exit/quit commands (case insensitive)
    - Basic error handling

2. **Input Handling** (`test_input_handling.sh`)
    - Multi-line SQL statements (basic)
    - Long SQL commands
    - SQL with quoted strings and special characters
    - Whitespace handling in commands
    - SQL comments (if supported)
    - Case insensitive SQL keywords
    - Rapid command sequences

3. **Basic Signal Handling** (`test_basic_signals.sh`)
    - EOF (Ctrl+D simulation) handling
    - SIGTERM signal handling
    - Process cleanup on exit
    - Graceful shutdown behavior
    - Broken pipe handling
    - Resource cleanup verification

### Running Tests

```bash
# Run all tests
./test-suite/phase-1/task-2/run_all_tests.sh

# Run specific test category
./test-suite/phase-1/task-2/run_all_tests.sh --test basic
./test-suite/phase-1/task-2/run_all_tests.sh --test input
./test-suite/phase-1/task-2/run_all_tests.sh --test signals

# Specify custom implementation path
./test-suite/phase-1/task-2/run_all_tests.sh --implementation my-custom-path
```

### Success Criteria

**Minimum Requirements** (must pass):

- ✅ Interactive prompt display
- ✅ Command execution with mock responses
- ✅ Exit command handling
- ✅ Basic signal handling (Ctrl+D, SIGTERM)
- ✅ Process cleanup on termination

**Full Implementation** (recommended):

- ✅ Multi-line SQL support
- ✅ Various input format handling
- ✅ Robust error handling
- ✅ Clean resource management

## Common Pitfalls

1. **Blocking Input**: Ensure your input reading doesn't block indefinitely
2. **Signal Handling**: Implement basic signal handlers for clean shutdown
3. **Resource Cleanup**: Always clean up resources on exit
4. **Cross-Platform Issues**: Test on different operating systems if possible
5. **Third-Party Dependencies**: Avoid external libraries for maximum compatibility

## Next Steps

After completing this task and passing the test suite:

1. Verify your implementation handles all test scenarios
2. Review code for cross-language compatibility principles
3. Proceed to **Task 3: Output Formatting** to enhance response presentation
4. Consider how your interactive shell will integrate with the database engine in later phases

Your interactive shell implementation provides the foundation for user interaction throughout all subsequent development
phases.