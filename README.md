# Real Engineer Project: Student Guide

## 🎯 What You'll Build

You'll create a complete **three-tier system** from scratch: a command-line **client**, a networked **server**, and a persistent **database engine**. This mirrors real-world software architecture and teaches you how client-server systems, network protocols, and storage engines work together.

**The Three Components:**
1. **Client**: Interactive SQL shell with networking capabilities
2. **Server**: Multi-threaded TCP server handling client connections
3. **Database**: SQL parser, query engine, and persistent storage with B+ trees

## 🚀 Quick Start

### Prerequisites

- Programming language of choice (Rust, C++, Go, Java, C#, Python, etc.)
- Unix-like system (Linux, macOS, or WSL)
- Git and your preferred code editor

### Setup

```bash
# 1. Navigate to your implementation directory
cd student-submissions/my-implementation

# 2. Initialize your project
# For Rust: cargo init
# For Go: go mod init my-db
# For Java: create your project structure
# For Python: create virtual environment

# 3. Test that everything works
cd ../../
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation
```

## 📚 Learning Path

### Phase 1: Command-Line Client (Weeks 1-2)

**Goal**: Build a robust SQL shell with excellent user experience

**What to build**:
- **Interactive Shell**: Command-line interface with readline support
- **Input Handling**: Accept commands via stdin, files, or arguments
- **Command Parsing**: Recognize SQL commands and handle multi-line input
- **Output Formatting**: Beautiful table display with proper alignment
- **Error Handling**: User-friendly error messages and help text
- **Command History**: Arrow key navigation and auto-completion

**Key Components**:
- `client` executable (main entry point)
- Input parser module
- Table formatter module
- Command history manager

**Skills You'll Learn**: CLI design, user experience, input validation, text formatting

**Test it**: Your client should handle complex SQL gracefully and display results beautifully

### Phase 2: Network Server (Weeks 3-6)

**Goal**: Build a production-ready TCP server with robust networking

**What to build**:
- **TCP Server**: Accept and manage client connections on configurable port
- **Protocol Handler**: Implement JSON-based client-server protocol
- **Concurrency**: Handle multiple clients simultaneously with threading/async
- **Connection Management**: Graceful client connect/disconnect handling
- **Error Recovery**: Robust error handling and client isolation
- **Logging System**: Structured logging for debugging and monitoring
- **Configuration**: Command-line options and config file support

**Key Components**:
- `server` executable (main server process)
- Connection manager module
- Protocol handler module
- Logging and configuration modules

**Skills You'll Learn**: Network programming, concurrent systems, protocol design, error handling

**Test it**: Server should handle 100+ concurrent clients without crashing

### Phase 3: Database Engine - SQL Processing (Weeks 7-12)

**Goal**: Build a complete SQL query engine from scratch

**What to build**:
- **SQL Lexer**: Tokenize SQL into keywords, identifiers, operators, literals
- **SQL Parser**: Build Abstract Syntax Trees (AST) from SQL tokens
- **Type System**: Support INTEGER, VARCHAR, BOOLEAN, DECIMAL data types
- **Query Executor**: Execute parsed queries on in-memory data structures
- **Data Storage**: Hash maps for tables, efficient row storage
- **Query Features**: SELECT with WHERE, ORDER BY, JOINs, aggregate functions
- **DDL Support**: CREATE TABLE, DROP TABLE, ALTER TABLE
- **Error Reporting**: Detailed syntax errors with line numbers

**Key Components**:
- Lexer module (tokenization)
- Parser module (AST construction)
- Query planner module
- Execution engine module
- In-memory storage module

**Skills You'll Learn**: Compiler design, formal languages, algorithm implementation, data structures

**Test it**: Execute complex SQL queries with joins and aggregations correctly

### Phase 4: Database Engine - Persistent Storage (Weeks 13-16)

**Goal**: Replace in-memory storage with high-performance disk-based storage

**What to build**:
- **Page Manager**: 4KB page-based file I/O with buffer pool
- **Storage Format**: Efficient on-disk record and page layouts
- **B+ Tree Indexes**: Disk-based B+ trees for primary and secondary indexes
- **Buffer Pool**: LRU cache for frequently accessed pages
- **Crash Recovery**: Write-ahead logging for data durability
- **Index Integration**: Query planner uses indexes for optimization
- **File Management**: Database files, index files, log files

**Key Components**:
- Page manager module
- B+ tree implementation
- Buffer pool manager
- File I/O abstraction layer
- Index manager module

**Skills You'll Learn**: Operating systems concepts, tree algorithms, performance optimization, file systems

**Test it**: Handle millions of records with sub-second query times

### Phase 5: Production Features (Weeks 17-18)

**Goal**: Add enterprise-grade features for real-world deployment

**What to build**:
- **ACID Transactions**: BEGIN, COMMIT, ROLLBACK with proper isolation
- **Concurrency Control**: Two-phase locking with deadlock detection
- **Write-Ahead Logging**: Ensure durability and enable crash recovery
- **Performance Monitoring**: Query execution statistics and profiling
- **Administrative Tools**: Database backup, restore, and maintenance
- **Security Features**: Basic authentication and access control

**Skills You'll Learn**: Transaction processing, concurrency control, system administration, security

## 🧪 Testing Strategy

### How Testing Works

1. **Automated Tests**: Run `./tools/test-runner/run_tests.sh` to verify your implementation
2. **JSON Protocol**: Your server communicates using simple JSON messages
3. **Standard Interface**: Tests work the same regardless of your programming language
4. **Progressive Complexity**: Tests get more challenging as you advance through phases

### Test Commands

```bash
# Test current phase only
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation

# Test all completed phases
./tools/test-runner/run_tests.sh --all --implementation student-submissions/my-implementation

# Run with performance benchmarks
./tools/test-runner/run_tests.sh --phase 3 --implementation student-submissions/my-implementation --benchmark
```

## 📈 Progress Tracking

### Certification Levels

- **🥉 Bronze**: Complete Phases 1-2 (Client + Server)
- **🥈 Silver**: Complete Phases 1-3 (+ SQL Processing)
- **🥇 Gold**: Complete Phases 1-4 (+ Persistent Storage)
- **💎 Platinum**: Complete All Phases (+ Advanced Features)

### Phase Completion Checklist

For each phase, ensure you have:

- ✅ All functionality tests passing
- ✅ Performance benchmarks met
- ✅ Code documented and clean
- ✅ Additional test cases for edge cases

## 🛠️ Implementation Tips

### Start Simple

- Begin with the minimal implementation that passes tests
- Don't optimize prematurely
- Focus on correctness first, performance later

### Test Frequently

- Run tests after every major change
- Use the provided test data for development
- Write your own test cases for edge cases

### Study the Reference

- Check `reference-implementation/` for guidance
- Understand the concepts before coding
- Don't copy-paste, but learn the patterns

### Common Patterns

1. **Error Handling**: Always validate input and handle errors gracefully
2. **Logging**: Add logging early for debugging
3. **Testing**: Write unit tests alongside your implementation
4. **Documentation**: Comment your code, especially complex algorithms

## 🔧 Protocol Specification

### Client-Server Communication

Your server should accept JSON messages over TCP:

**Query Request**:

```json
{
  "type": "query",
  "sql": "SELECT * FROM users WHERE age > 25"
}
```

**Response**:

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "name": "Alice",
      "age": 30
    },
    {
      "id": 2,
      "name": "Bob",
      "age": 28
    }
  ],
  "error": null
}
```

**Error Response**:

```json
{
  "status": "error",
  "data": null,
  "error": "Table 'users' does not exist"
}
```

## 🆘 Getting Help

### When You're Stuck

1. **Check the docs**: Look in `docs/phase-guides/` for detailed explanations
2. **Run tests**: Use test output to understand what's expected
3. **Study reference**: Look at the Rust implementation for guidance
4. **Ask questions**: Use the community forum
5. **Office hours**: Attend weekly virtual sessions

## Next Steps

1. **Choose your language** and set up your development environment
2. **Read Phase 1 guide** in `docs/phase-guides/phase-1-client-interface.md`
3. **Start coding** your command-line client
4. **Run tests early and often**

Remember: You're building a complete **three-tier system**. Each component teaches different skills:
- **Client**: User experience and interface design
- **Server**: Network programming and concurrent systems  
- **Database**: Algorithms, data structures, and storage systems

Take time to understand how all three components work together to create a production system.

**Ready to become a real engineer? Start building!**