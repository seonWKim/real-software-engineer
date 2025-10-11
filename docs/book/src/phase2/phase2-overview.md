# Phase 2 Overview: Network Server

![Phase 2 Overview](./images/phase2-overview.svg)

In the second phase of the project, you will build the **network server** that acts as the communication bridge between
clients and the database engine. The server is intentionally focused on networking concerns - it handles TCP
connections, JSON protocol, and routes requests without understanding SQL semantics.

## Learning Objectives

By completing Phase 2, you will gain practical experience in:

- **Network Programming**: TCP sockets, connection handling, and protocol design
- **Concurrent Programming**: Managing multiple client connections safely
- **Protocol Implementation**: JSON-based client-server communication
- **System Design**: Building robust, scalable server architectures
- **Logging and Monitoring**: Observability for production systems
- **Configuration Management**: Flexible server configuration patterns

## What You'll Build

### Core Features

- **TCP Server**: Accept and manage multiple client connections
- **Custom Protocol**: Simple structured request/response communication
- **SQL Routing**: Forward raw SQL strings to database engine
- **Connection Management**: Handle client lifecycle and resource cleanup
- **Structured Logging**: Comprehensive logging for debugging and monitoring
- **Configuration**: Flexible settings from multiple sources
- **Graceful Shutdown**: Clean server termination and resource cleanup

### Server Architecture - Pure Pass-Through

```
server/
├── main.{ext}                # Entry point and configuration
├── tcp/
│   ├── listener.{ext}        # TCP server and connection acceptance
│   └── handler.{ext}         # Individual client connection handling
├── protocol/
│   ├── message.{ext}         # Custom protocol request/response parsing
│   ├── framing.{ext}         # TCP message framing
│   └── router.{ext}          # Route requests to database engine
├── connection/
│   ├── manager.{ext}         # Connection pool and lifecycle
│   ├── limits.{ext}          # Connection limits and timeouts
│   └── cleanup.{ext}         # Resource cleanup
├── logging/
│   ├── structured.{ext}      # Structured logging implementation
│   └── metrics.{ext}         # Performance metrics collection
└── config/
    ├── settings.{ext}        # Configuration management
    └── args.{ext}            # Command-line argument parsing
```

## Task Breakdown

### Task 1: Basic TCP Server

Set up a TCP server that can accept client connections and handle the connection lifecycle with proper error handling.

### Task 2: Custom Protocol Implementation

Define and implement the custom protocol for client-server communication, focusing on message structure and
validation.

### Task 3: Message Framing

Implement proper TCP message framing to handle the stream nature of TCP and ensure complete message delivery.

### Task 4: Concurrency Implementation

Choose and implement a concurrency model (threads, thread pools, or async I/O) to handle multiple clients
simultaneously.

### Task 5: Connection Management

Build robust connection lifecycle management with proper resource cleanup, timeouts, and connection limits.

### Task 6: Configuration System

Implement flexible configuration from command-line arguments, environment variables, and configuration files.

### Task 7: Logging and Monitoring

Add comprehensive structured logging and basic performance metrics collection for observability.

### Task 8: Client Integration

Integrate with your Phase 1 client and prepare the server for Phase 3 database engine integration.

## Server Role: Pure Networking Layer

**🎯 Key Principle: Server as Router**

The Phase 2 server has **zero SQL intelligence**. Its only job is:

1. **Accept** client TCP connections
2. **Parse** protocol messages to extract raw SQL strings
3. **Forward** SQL strings to database engine (function calls)
4. **Package** database results into protocol responses
5. **Send** protocol responses back to clients
6. **Manage** connection lifecycle and resources

The server never parses, validates, or understands SQL - it's purely a networking and routing layer.

## Success Criteria

### Functionality

- ✅ Handles 100+ concurrent client connections
- ✅ Processes custom protocol messages correctly
- ✅ Forwards raw SQL strings to database engine
- ✅ Maintains stable operation under load
- ✅ Graceful startup and shutdown procedures

### Performance

- ✅ < 10ms message processing latency
- ✅ < 50ms connection establishment time
- ✅ Efficient memory usage per connection
- ✅ Stable performance under sustained load

### Reliability

- ✅ No crashes under normal operation
- ✅ Proper cleanup of disconnected clients
- ✅ Recovery from network failures
- ✅ Resource leak prevention

### Monitoring

- ✅ Structured logging for all events
- ✅ Performance metrics collection
- ✅ Error tracking and reporting
- ✅ Operational visibility

## Performance Requirements

| Metric | Target | Rationale |
|--------|--------|-----------|
| Concurrent Connections | 100+ | Support multiple users simultaneously |
| Message Latency | < 10ms | Responsive user experience |
| Connection Setup | < 50ms | Fast client connection establishment |
| Memory per Connection | < 1MB | Scalable resource usage |
| Throughput | 1000+ msg/sec | Handle high request volumes |

## Testing Strategy

### Unit Tests

- Custom protocol parsing and generation
- Connection management logic
- Configuration loading and validation
- Error handling scenarios
- Message framing implementation

### Integration Tests

- Client-server communication end-to-end
- Multiple concurrent client scenarios
- Network failure simulation
- Server startup and shutdown procedures

### Load Tests

- Concurrent connection limits
- Request processing throughput
- Memory usage under load
- Connection establishment/teardown performance

### Network Tests

- TCP connection handling
- Message framing correctness
- Network interruption recovery
- Protocol compliance validation

## Phase 2 ↔ Phase 3 Integration

### For Phase 2 (Mock Integration)

```rust
// Server forwards to mock database engine
fn handle_sql_request(sql: &str) -> QueryResult {
    // Mock database response
    QueryResult {
        columns: vec!["id".to_string(), "name".to_string()],
        rows: vec![
            vec!["1".to_string(), "Alice".to_string()],
            vec!["2".to_string(), "Bob".to_string()],
        ],
        execution_time_ms: 5,
    }
}
```

### For Phase 3 (Real Integration)

```rust
// Server forwards to real database engine
fn handle_sql_request(sql: &str) -> QueryResult {
    // Forward to database engine (function call, not network)
    database_engine.execute_sql(sql)
}
```

The server interface remains identical - only the implementation of `handle_sql_request` changes!

## Preparation for Phase 3

Your Phase 2 server should be architected to easily integrate with a database engine:

- **Function Call Interface**: Design for database engine function calls, not network calls
- **Result Handling**: Plan for structured query results from database
- **Error Propagation**: Handle database errors and forward to clients
- **Performance**: Minimize overhead between client requests and database execution

## Common Challenges

**⚠️ Common Pitfalls:**

- **Resource Leaks**: Always clean up client connections and threads
- **Thread Safety**: Protect shared data structures with proper synchronization
- **Error Isolation**: Don't let one client's errors affect others
- **Message Framing**: Handle TCP stream boundaries correctly
- **Memory Management**: Limit per-client memory usage to prevent DoS
- **Graceful Shutdown**: Properly close all connections on server exit

## Language-Specific Considerations

### Rust

- Use `tokio` for async networking or `std::thread` for threading
- Leverage `serde` for JSON handling and `tracing` for logging
- Consider connection pooling and resource management patterns

### C++

- Use `std::thread` or `boost::asio` for networking
- Implement careful memory management and RAII patterns
- Use `nlohmann/json` for JSON and `spdlog` for logging

### Go

- Use goroutines for natural concurrency handling
- Leverage built-in `net` and `encoding/json` packages
- Use channels for communication between goroutines

### Python

- Use `asyncio` for async I/O or `threading` for thread-based concurrency
- Leverage built-in `json` and `logging` modules
- Consider connection pooling libraries

### Java

- Use NIO for high-performance networking
- Leverage `Jackson` for JSON and `Logback` for logging
- Use thread pools and connection management patterns

## Ready to Start?

Phase 2 creates the communication backbone that connects your client to your database. Focus on building a robust,
reliable networking layer that can handle multiple clients efficiently while maintaining clear separation from SQL
processing logic.

**Next**: Begin with [Task 1: Basic TCP Server](./phase2-01-tcp-server.md) to start building your network server.