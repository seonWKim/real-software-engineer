# Project Overview

## 🎯 What You'll Build

You'll create a complete **three-tier database system** from scratch: an interactive **client**, a networked **server**,
and a persistent **database engine**. This mirrors real-world software architecture and teaches systems programming
fundamentals.

![System Architecture](./images/architecture-overview.svg)

### The Three Components

#### 1. **Client**: Interactive SQL Shell

- Command-line interface with readline support
- Beautiful table formatting and error handling
- Network communication with the server

#### 2. **Server**: Multi-threaded TCP Server

- JSON-based protocol for client communication
- Concurrent client handling with proper isolation
- Structured logging and monitoring
- Configuration management and graceful shutdown

#### 3. **Database**: SQL Query Engine + Storage

- **SQL Processing**: Lexer, parser, and query execution
- **Type System**: INTEGER, VARCHAR, BOOLEAN, DECIMAL with NULL handling
- **Storage Engine**: B+ tree indexes and page-based file I/O
- **Transactions**: ACID properties with concurrency control

## 🏗️ Architecture Deep Dive

### Client-Server Communication

```
┌─────────────┐    JSON/TCP    ┌─────────────┐    Function    ┌─────────────┐
│   Client    │◄──────────────►│   Server    │     Calls      │  Database   │
│             │   Raw SQL      │             │   Raw SQL      │   Engine    │
│ - CLI       │                │ - TCP       │                │ - Parser    │
│ - Formatter │                │ - Protocol  │                │ - Executor  │
│ - Network   │                │ - Routing   │                │ - Storage   │
└─────────────┘                └─────────────┘                └─────────────┘
```

### Data Flow Example

1. **User Input**: `SELECT name, age FROM users WHERE age > 25;`
2. **Client**: Sends raw SQL string in JSON request to server
3. **Server**: Receives JSON, extracts SQL, forwards to database engine
4. **Database**: Lexes → Parses → Executes → Returns results
5. **Server**: Packages results as JSON, sends to client
6. **Client**: Receives JSON, displays formatted table to user

## 📚 Learning Progression

### Phase 1: Command-Line Client <span class="phase-badge phase-1">Weeks 1-2</span>

**Goal**: Build a robust SQL shell with excellent user experience

**What You'll Learn**:

- CLI design and user interface principles
- Input validation and error handling
- Cross-platform development considerations
- Configuration management patterns

**Key Technologies**:

- Readline libraries for interactive input
- Argument parsing frameworks
- Table formatting and terminal output
- File I/O and configuration parsing

### Phase 2: Network Server <span class="phase-badge phase-2">Weeks 3-6</span>

**Goal**: Create a production-ready TCP server

**What You'll Learn**:

- Network programming and TCP sockets
- Concurrent programming patterns
- Protocol design and message framing
- Structured logging and monitoring

**Key Technologies**:

- TCP socket programming
- Threading or async I/O
- JSON parsing and generation
- Logging frameworks

### Phase 3: SQL Processing <span class="phase-badge phase-3">Weeks 7-12</span>

**Goal**: Build a complete SQL query engine

**What You'll Learn**:

- Formal language theory and parsing
- Compiler design principles
- Type systems and expression evaluation
- Query optimization fundamentals

**Key Technologies**:

- Lexical analysis and tokenization
- Recursive descent parsing
- Abstract syntax trees (ASTs)
- Hash maps and efficient data structures

### Phase 4: Persistent Storage <span class="phase-badge phase-4">Weeks 13-16</span>

**Goal**: Implement disk-based storage with B+ trees

**What You'll Learn**:

- Operating system file I/O
- Tree algorithms and disk-based data structures
- Buffer management and caching
- Crash recovery and durability

**Key Technologies**:

- File system APIs
- B+ tree algorithms
- Memory management and caching
- Write-ahead logging

### Phase 5: Production Features <span class="phase-badge phase-5">Weeks 17-18</span>

**Goal**: Add enterprise-grade features

**What You'll Learn**:

- Transaction processing theory
- Concurrency control mechanisms
- System administration and monitoring
- Performance optimization techniques

**Key Technologies**:

- Two-phase locking
- Deadlock detection
- Performance metrics collection
- Administrative tooling

## 🎯 Success Metrics

### Certification Levels

- **🥉 Bronze**: Client + Server (Phases 1-2)
- **🥈 Silver**: + SQL Processing (Phase 3)
- **🥇 Gold**: + Persistent Storage (Phase 4)
- **💎 Platinum**: + Production Features (Phase 5)

### Performance Targets

<table class="perf-table">
<tr><th>Component</th><th>Metric</th><th>Target</th></tr>
<tr><td>Client</td><td>Startup time</td><td>&lt; 500ms</td></tr>
<tr><td>Client</td><td>Command response</td><td>&lt; 100ms</td></tr>
<tr><td>Server</td><td>Concurrent connections</td><td>100+</td></tr>
<tr><td>Server</td><td>Message latency</td><td>&lt; 10ms</td></tr>
<tr><td>Database</td><td>Simple queries (1K records)</td><td>&lt; 10ms</td></tr>
<tr><td>Database</td><td>Complex queries (10K records)</td><td>&lt; 100ms</td></tr>
<tr><td>Storage</td><td>B+ tree operations</td><td>&lt; 1ms</td></tr>
<tr><td>System</td><td>Transaction throughput</td><td>&gt; 1000 TPS</td></tr>
</table>

## 🧪 Testing Strategy

### Language-Agnostic Validation

All testing uses standardized interfaces that work regardless of your implementation language:

- **Client Testing**: Command-line interface validation
- **Server Testing**: JSON protocol compliance over TCP
- **Database Testing**: SQL query correctness and performance
- **Integration Testing**: End-to-end system validation

### Test Execution

```bash
# Test specific phase
./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation

# Test all completed phases
./tools/test-runner/run_tests.sh --all --implementation student-submissions/my-implementation

# Include performance benchmarks
./tools/test-runner/run_tests.sh --phase 3 --implementation student-submissions/my-implementation --benchmark
```

## 🚀 Getting Started

Ready to begin your journey? Here's your first steps:

1. **Choose Your Language**: Select a systems programming language you're comfortable with
2. **Set Up Environment**: Install required tools and dependencies
3. **Read Phase 1 Guide**: Understand the client requirements
4. **Start Building**: Begin with the basic CLI structure
5. **Test Early and Often**: Run tests to validate each step

The next chapter will guide you through the complete environment setup process.

**Let's build your database system!** 🔧