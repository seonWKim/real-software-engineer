# Real Engineer Project: Build Your Own Database System

## Project Overview

Welcome to the Real Engineer Project - a comprehensive, hands-on journey to build a complete database management
system (RDBMS) from scratch. This project is designed to transform students into real engineers by providing deep
understanding of how databases, servers, operating systems, and programming languages work together in production
systems.

### 🎯 Learning Objectives

By completing this project, you will gain practical experience in:

- **Database Internals**: Storage engines, indexing, query optimization, transaction management
- **Systems Programming**: Memory management, file I/O, network programming, concurrency
- **Programming Language Design**: Lexing, parsing, AST construction, query planning
- **Server/Client Architecture**: Network protocols, connection handling, distributed systems
- **Operating Systems Concepts**: Process management, memory allocation, file systems
- **Real-World Engineering**: Testing, performance optimization, production considerations

### 🏗️ Project Architecture

The database system consists of four main components:

1. **Client Interface**: Command-line interface, protocol implementation
2. **Server**: Network protocol, connection handling, command processing  
3. **Query Parser**: SQL lexer/parser, abstract syntax trees, query planning
4. **Storage Engine**: Core data structures, B+ trees, page management, file I/O

## Implementation Phases

### Phase 1: Client Interface Foundation (Weeks 1-2)

**Objective**: Build the user-facing interface that makes testing and development easier.

#### Week 1-2: Command-Line Client with Mock Backend

- **Goals**: Create testable interface and understand protocol design
- **Deliverables**:
    - Interactive SQL shell with command history and auto-completion
    - Mock database backend with hardcoded responses
    - Basic protocol specification (JSON over TCP for simplicity)
    - Result formatting and display with table output
- **Key Concepts**: User interface design, command parsing, network protocols
- **Testing**: CLI functionality tests with automated input/output verification
- **Benefits**: Students can immediately see results and test framework can easily validate outputs

### Phase 2: Server Implementation (Weeks 3-6)

**Objective**: Build a networked database server that the client can connect to.

#### Week 3-4: Basic Server and Protocol

- **Goals**: Establish client-server communication 
- **Deliverables**:
    - TCP server accepting client connections
    - JSON-based protocol implementation (easier to debug than binary)
    - Basic command processing (connect, disconnect, ping, mock queries)
    - Connection management and graceful shutdown
- **Key Concepts**: Network programming, protocol design, serialization
- **Testing**: Protocol compliance tests using the Phase 1 client

#### Week 5-6: Multi-Client Support and Error Handling

- **Goals**: Handle multiple clients and robust error management
- **Deliverables**:
    - Multi-threaded connection handling
    - Comprehensive error handling and reporting
    - Basic authentication and session management
    - Logging and debugging capabilities
- **Key Concepts**: Concurrent programming, error handling, debugging
- **Testing**: Multi-client tests using multiple instances of Phase 1 client

### Phase 3: Query Parser and Execution (Weeks 7-12)

**Objective**: Parse SQL and execute queries with in-memory data structures.

#### Week 7-8: SQL Lexer and Parser

- **Goals**: Understand programming language implementation fundamentals
- **Deliverables**:
    - SQL lexer for basic tokens (keywords, identifiers, literals, operators)
    - Recursive descent parser for SELECT, INSERT, UPDATE, DELETE
    - Abstract Syntax Tree (AST) representation
    - Error reporting with line numbers and suggestions
- **Key Concepts**: Formal languages, context-free grammars, parsing algorithms  
- **Testing**: SQL parsing tests integrated with client-server communication

#### Week 9-10: In-Memory Query Execution

- **Goals**: Execute parsed queries on in-memory data
- **Deliverables**:
    - In-memory table structures (hash maps, vectors)
    - Basic query executor for single-table operations
    - Support for WHERE clauses, ORDER BY, basic JOINs
    - Result set generation and formatting
- **Key Concepts**: Data structures, algorithm implementation, query processing
- **Testing**: End-to-end SQL execution tests through client interface

#### Week 11-12: Query Planning and Optimization

- **Goals**: Optimize query execution and add advanced features
- **Deliverables**:
    - Basic query planner and optimizer
    - Index usage for simple queries (in-memory indexes)
    - Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
    - Subquery support
- **Key Concepts**: Query optimization, cost models, algorithm complexity
- **Testing**: Performance comparisons and correctness tests for complex queries

### Phase 4: Persistent Storage Engine (Weeks 13-16)

**Objective**: Replace in-memory storage with persistent, disk-based storage.

#### Week 13-14: File-Based Storage

- **Goals**: Understand file-based data storage and persistence
- **Deliverables**:
    - Page-based file I/O system (4KB pages)
    - Basic record storage and retrieval  
    - Simple heap file organization
    - Data persistence across server restarts
- **Key Concepts**: Operating system file I/O, memory mapping, page structures
- **Testing**: Data persistence tests using client to insert/query across restarts

#### Week 15-16: Indexing with B+ Trees

- **Goals**: Implement efficient data access through disk-based indexing
- **Deliverables**:
    - B+ tree implementation for integer and string keys
    - Insert, delete, and search operations on disk
    - Tree balancing and split/merge operations
    - Integration with query executor
- **Key Concepts**: Tree algorithms, disk-based data structures, performance analysis
- **Testing**: Index performance tests and correctness verification through client

### Phase 5: Advanced Features (Weeks 17-18)

**Objective**: Implement production-ready features for real-world usage.

#### Week 15-16: Transaction Management

- **Goals**: Ensure ACID properties and data consistency
- **Deliverables**:
    - Transaction begin/commit/rollback operations
    - Write-ahead logging (WAL) for durability
    - Basic deadlock detection
- **Key Concepts**: Database transactions, logging, recovery algorithms
- **Testing**: Transaction isolation and consistency tests

#### Week 17-18: Performance and Optimization

- **Goals**: Optimize for real-world performance requirements
- **Deliverables**:
    - Query performance monitoring
    - Index optimization and statistics
    - Buffer pool management
- **Key Concepts**: Performance tuning, profiling, optimization techniques
- **Testing**: Performance benchmarks with standardized workloads

## Language-Agnostic Testing Strategy

### 🧪 Testing Framework

To ensure implementations work correctly regardless of programming language, all tests use standardized interfaces:

#### 1. Client Interface Testing (Phase 1)

- **Method**: Command-line interface testing with standardized input/output
- **Input**: SQL commands via stdin or command-line arguments
- **Output**: Formatted table results via stdout in JSON or tab-separated format
- **Verification**: Text comparison of output with expected results
- **Example**: `echo "SELECT * FROM users;" | ./my_client` → compare with expected output
- **Benefits**: Easy to test, debug, and verify across all programming languages

#### 2. Network Protocol Testing (Phase 2+)

- **Method**: TCP socket communication using JSON protocol (human-readable)
- **Test Suite**: Automated scripts that connect to server and send JSON messages
- **Protocol**: Simple JSON format: `{"type": "query", "sql": "SELECT * FROM users"}`
- **Response**: JSON format: `{"status": "success", "data": [...], "error": null}`
- **Language Support**: JSON parsing available in all modern languages
- **Example**: Test runner connects, sends query, verifies JSON response structure

#### 3. SQL Compliance Testing (Phase 3+)

- **Standard**: Subset of SQL-92 specification with clearly defined grammar
- **Test Cases**: Progressive SQL complexity from simple SELECT to complex JOINs
- **Format**: `.sql` files with corresponding `.json` expected results
- **Validation**: JSON comparison with tolerance for floating-point precision
- **Client Integration**: All tests run through the client interface for consistency

#### 4. Performance Benchmarking

- **Datasets**: Standardized test datasets of various sizes (1K, 10K, 100K, 1M records)
- **Metrics**: Query execution time, memory usage, disk I/O
- **Reporting**: JSON-formatted performance reports for automated analysis
- **Baseline**: Reference implementation benchmarks for comparison

### 🎯 Test Execution

```bash
# Phase 1: Test client interface with mock data
./test_runner.sh --phase 1 --client ./my_client

# Phase 2: Test client + server communication  
./test_runner.sh --phase 2 --client ./my_client --server ./my_server

# Phase 3+: Full end-to-end testing
./test_runner.sh --phase 3 --client ./my_client --server ./my_server

# All phases with performance benchmarking
./test_runner.sh --all --client ./my_client --server ./my_server --benchmark
```

### 📊 Test Reporting

- **Correctness**: Pass/fail for each test case with detailed error messages
- **Performance**: Execution time and resource usage statistics
- **Compliance**: SQL standard compliance percentage
- **Progress**: Phase completion tracking with visual progress indicators

## Project Structure

```
real-engineer-db/
├── docs/                          # Comprehensive documentation
│   ├── phase-guides/              # Detailed phase instructions
│   ├── concepts/                  # Technical concept explanations
│   ├── reference/                 # API and protocol specifications
│   └── troubleshooting/           # Common issues and solutions
├── reference-implementation/       # Rust reference implementation
│   ├── client/                    # Phase 1 implementation
│   ├── server/                    # Phase 2 implementation
│   ├── query-parser/              # Phase 3 implementation
│   └── storage-engine/            # Phase 4 implementation
├── test-suite/                    # Language-agnostic tests
│   ├── phase-1/                   # Client interface tests
│   ├── phase-2/                   # Server communication tests
│   ├── phase-3/                   # Query processing tests
│   ├── phase-4/                   # Storage engine tests
│   ├── integration/               # End-to-end tests
│   └── performance/               # Benchmark tests
├── test-data/                     # Standardized test datasets
│   ├── small/                     # Development datasets
│   ├── medium/                    # Integration datasets
│   └── large/                     # Performance datasets
├── tools/                         # Development and testing tools
│   ├── test-runner/               # Language-agnostic test runner
│   ├── benchmark/                 # Performance testing tools
│   ├── protocol-tester/           # Network protocol validator
│   └── data-generator/            # Test data generation tools
└── student-submissions/           # Template for student work
    ├── my-implementation/         # Student code directory
    ├── test-results/              # Generated test reports
    └── benchmarks/                # Performance results
```

## Getting Started

### Prerequisites

- **Programming Language**: Choose any systems programming language (Rust, C++, Go, Java, C#, etc.)
- **Development Environment**: Unix-like system (Linux, macOS, WSL on Windows)
- **Tools**: Git, language-specific compiler/interpreter, text editor or IDE

### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-org/real-engineer-db.git
   cd real-engineer-db
   ```

2. **Choose Your Implementation Language**
   ```bash
   mkdir student-submissions/my-implementation
   cd student-submissions/my-implementation
   # Initialize your project (cargo init, npm init, etc.)
   ```

3. **Run Initial Tests**
   ```bash
   cd ../../
   ./tools/test-runner/run_tests.sh --phase 1 --implementation student-submissions/my-implementation
   ```

4. **Study the Phase 1 Guide**
   ```bash
   open docs/phase-guides/phase-1-client-interface.md
   ```

### Implementation Guidelines

1. **Start Small**: Begin with the simplest possible implementation that passes tests
2. **Iterate**: Gradually add features and optimize performance
3. **Test Frequently**: Run tests after each significant change
4. **Read Documentation**: Each phase includes detailed concept explanations
5. **Study Reference**: Examine the Rust reference implementation for guidance
6. **Ask Questions**: Use the discussion forum for technical questions

## Assessment and Progress Tracking

### Phase Completion Criteria

Each phase requires:

- ✅ **Functionality**: All correctness tests pass
- ✅ **Performance**: Meet minimum performance benchmarks
- ✅ **Documentation**: Code documentation and implementation notes
- ✅ **Testing**: Additional test cases demonstrating edge case handling

### Certification Levels

- **🥉 Bronze**: Complete Phases 1-2 (Client Interface and Basic Server)
- **🥈 Silver**: Complete Phases 1-3 (Client, Server, and Query Processing)
- **🥇 Gold**: Complete Phases 1-4 (Full Persistent Database)
- **💎 Platinum**: Complete All Phases with Advanced Features and Optimizations

### Code Review Process

1. **Self-Assessment**: Use provided checklists for each phase
2. **Peer Review**: Optional peer code review with other students
3. **Automated Review**: Static analysis and code quality checks
4. **Expert Review**: Professional code review for certification candidates

## Resources and References

### Essential Reading

- **Database Systems**: "Database System Concepts" by Silberschatz, Korth, and Sudarshan
- **Algorithms**: "Introduction to Algorithms" by Cormen, Leiserson, Rivest, and Stein
- **Systems Programming**: "The Linux Programming Interface" by Kerrisk
- **Compilers**: "Crafting Interpreters" by Nystrom

### Online Resources

- **Database Internals**: [Database Internals by Alex Petrov](https://www.databass.dev/)
- **B+ Trees**: [B+ Tree Visualization](https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html)
- **SQL Standards**: [SQL-92 Specification](https://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt)
- **Network Programming**: [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/)

### Community Support

- **Discussion Forum**: Technical questions and peer support
- **Office Hours**: Weekly virtual sessions with instructors
- **Study Groups**: Local and online study group coordination
- **Mentorship**: Senior engineer mentorship program

## Future Enhancements

### Cloud Integration (Roadmap)

- **Automated Testing**: Cloud-based test execution and reporting
- **Code Submission**: Secure code repository with automated grading
- **Performance Analytics**: Detailed performance analysis and comparison
- **Collaboration Tools**: Team projects and code sharing capabilities

### Advanced Topics (Optional Modules)

- **Distributed Databases**: Sharding, replication, consensus algorithms
- **Analytics Engine**: Column stores, data warehousing, OLAP queries
- **Machine Learning Integration**: SQL extensions for ML workloads
- **Cloud Native**: Containerization, Kubernetes deployment, microservices

## Success Metrics

- **Technical Mastery**: Demonstrated understanding of core systems concepts
- **Code Quality**: Clean, maintainable, well-documented implementations
- **Problem Solving**: Ability to debug and optimize complex systems
- **Engineering Practices**: Testing, version control, documentation habits
- **Real-World Readiness**: Confidence to work on production database systems

---

**Ready to become a real engineer? Start with Phase 1 and build your first storage engine!**

For questions, support, or feedback, visit our [community forum](https://community.real-engineer.dev) or contact us
at [support@real-engineer.dev](mailto:support@real-engineer.dev).