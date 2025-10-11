# Environment Setup

This chapter guides you through setting up your development environment for building the database system.

## Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or Windows with WSL2
- **Memory**: At least 4GB RAM (8GB recommended)
- **Storage**: 2GB free space for tools and project files
- **Network**: Internet connection for downloading dependencies

### Required Tools

- **Git**: Version control and project management
- **Text Editor/IDE**: Your preferred code editor
- **Programming Language**: Choose one from the supported languages below

## Language Selection

Choose the programming language you're most comfortable with. All languages have equal support in the testing framework.

### Rust (Recommended for Learning)

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Verify installation
rustc --version
cargo --version
```

**Pros**: Memory safety, excellent performance, great ecosystem for systems programming
**Cons**: Steeper learning curve if you're new to Rust

### C++

```bash
# On Ubuntu/Debian
sudo apt update
sudo apt install build-essential cmake

# On macOS
xcode-select --install
brew install cmake

# Verify installation
g++ --version
cmake --version
```

**Pros**: Maximum control, extensive libraries, industry standard
**Cons**: Manual memory management, potential for security issues

### Go

```bash
# Download from https://golang.org/dl/
# Or on macOS
brew install go

# Verify installation
go version
```

**Pros**: Simple syntax, built-in concurrency, fast compilation
**Cons**: Garbage collection overhead, less control over memory

### Java

```bash
# Install OpenJDK
# On Ubuntu/Debian
sudo apt install openjdk-17-jdk maven

# On macOS
brew install openjdk@17 maven

# Verify installation
java --version
javac --version
mvn --version
```

**Pros**: Mature ecosystem, excellent tooling, cross-platform
**Cons**: Verbose syntax, JVM overhead

### Python

```bash
# Python 3.8+ required
python3 --version
pip3 --version

# Install virtual environment tools
pip3 install virtualenv pipenv
```

**Pros**: Rapid development, extensive libraries, easy debugging
**Cons**: Performance overhead, GIL limitations for concurrency

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/real-software-engineer.git
cd real-software-engineer
```

### 2. Navigate to Your Workspace

```bash
cd student-submissions/my-implementation
```

### 3. Initialize Your Project

#### For Rust

```bash
cargo init --name my-database
cd my-database

# Add dependencies to Cargo.toml
echo '[dependencies]
clap = "4.0"
rustyline = "12.0"
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }
tabled = "0.14"' >> Cargo.toml
```

#### For C++

```bash
mkdir my-database && cd my-database
mkdir src include tests

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyDatabase)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add your source files here
add_executable(client src/client.cpp)
add_executable(server src/server.cpp)

# Find and link libraries
find_package(Threads REQUIRED)
target_link_libraries(server Threads::Threads)
EOF
```

#### For Go

```bash
mkdir my-database && cd my-database
go mod init my-database

# Create basic structure
mkdir -p cmd/client cmd/server internal/database internal/server internal/client
```

#### For Java

```bash
mvn archetype:generate -DgroupId=com.example.database \
    -DartifactId=my-database \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DinteractiveMode=false

cd my-database
```

#### For Python

```bash
mkdir my-database && cd my-database
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Create requirements.txt
cat > requirements.txt << 'EOF'
click>=8.0.0
prompt-toolkit>=3.0.0
tabulate>=0.9.0
aiofiles>=0.8.0
asyncio>=3.4.3
EOF

pip install -r requirements.txt
```

### 4. Create Basic Directory Structure

Regardless of language, organize your code like this:

<div class="file-tree">
my-database/
├── client/                    # Phase 1: CLI client
│   ├── main.{ext}            # Entry point
│   ├── cli/                  # Interactive shell
│   ├── formatter/            # Output formatting
│   └── config/               # Configuration
├── server/                   # Phase 2: Network server
│   ├── main.{ext}            # Server entry point
│   ├── tcp/                  # TCP server
│   ├── protocol/             # JSON protocol
│   └── connection/           # Connection management
├── database/                 # Phase 3-5: Database engine
│   ├── lexer/                # SQL tokenization
│   ├── parser/               # AST construction
│   ├── executor/             # Query execution
│   └── storage/              # Storage engine
├── tests/                    # Unit tests
├── docs/                     # Documentation
└── README.md                 # Project overview
</div>

## Test Framework Setup

### 1. Verify Test Runner

```bash
# From the root project directory
./tools/test-runner/run_tests.sh --help
```

### 2. Run Initial Tests

```bash
# This should show available tests (will fail until you implement)
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation
```

### 3. Understand Test Output

The test runner will:

- ✅ **PASS**: Your implementation meets requirements
- ❌ **FAIL**: Issues found, check error messages
- ⚠️ **SKIP**: Test not applicable to current phase

## Development Tools (Optional but Recommended)

### Language Servers and IDE Setup

#### VS Code Extensions

- **Rust**: rust-analyzer
- **C++**: C/C++ Extension Pack
- **Go**: Go extension
- **Java**: Extension Pack for Java
- **Python**: Python extension

#### Useful Tools

```bash
# Code formatting and linting
# Choose based on your language

# For any language - general tools
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Install ripgrep for fast searching
# On macOS
brew install ripgrep
# On Ubuntu/Debian
sudo apt install ripgrep
```

### Database Tools (For Reference)

```bash
# Install SQLite for reference and testing
# On macOS
brew install sqlite3
# On Ubuntu/Debian
sudo apt install sqlite3

# Install PostgreSQL client for protocol comparison
# On macOS
brew install postgresql
# On Ubuntu/Debian
sudo apt install postgresql-client
```

## Verification

### Test Your Setup

Run this verification script to ensure everything is working:

```bash
# Create a simple test program
# For Rust
echo 'fn main() { println!("Hello, Database!"); }' > test.rs
rustc test.rs && ./test

# For C++
echo '#include <iostream>
int main() { std::cout << "Hello, Database!" << std::endl; }' > test.cpp
g++ test.cpp -o test && ./test

# For Go
echo 'package main
import "fmt"
func main() { fmt.Println("Hello, Database!") }' > test.go
go run test.go

# For Java
echo 'public class Test { public static void main(String[] args) { 
System.out.println("Hello, Database!"); } }' > Test.java
javac Test.java && java Test

# For Python
echo 'print("Hello, Database!")' > test.py
python3 test.py

# Clean up
rm test*
```

### Check Dependencies

Make sure you can import/include the essential libraries for your chosen language.

## Common Issues

### Permission Errors

```bash
# If you get permission errors with test runner
chmod +x tools/test-runner/run_tests.sh
```

### Path Issues

```bash
# Ensure tools are in your PATH
export PATH=$PATH:$(pwd)/tools/test-runner
```

### Language-Specific Issues

#### Rust

- **Issue**: `cargo` command not found
- **Solution**: Restart terminal or run `source ~/.cargo/env`

#### C++

- **Issue**: Missing compiler
- **Solution**: Install build tools for your platform

#### Go

- **Issue**: Module not found
- **Solution**: Ensure you're in the correct directory with `go.mod`

#### Java

- **Issue**: Wrong Java version
- **Solution**: Install Java 11+ and set `JAVA_HOME`

#### Python

- **Issue**: Import errors
- **Solution**: Activate virtual environment and install requirements

## Next Steps

Once your environment is set up:

1. **Familiarize yourself** with the project structure
2. **Read the Phase 1 Overview** to understand the client requirements
3. **Start with Task 1** of Phase 1: Basic CLI Structure
4. **Run tests frequently** to validate your progress

<div class="success-box">
<h4>✅ Environment Ready!</h4>
Your development environment is now configured. You're ready to start building your database system!
</div>

**Ready to code? Let's move on to Phase 1!** 🚀