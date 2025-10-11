# Phase 2: Network Server

In this phase, you will:

* Implement a TCP server that accepts multiple concurrent client connections
* Build a JSON-based protocol for client-server communication
* Create robust connection management and error handling
* Implement structured logging and monitoring

To copy the test cases and run them,

```
./tools/test-runner/run_tests.sh --phase 2 --implementation student-submissions/my-implementation
```

## Task 1: Basic TCP Server

In this task, you will need to create:

```
server/
├── main.{rs,cpp,py,go,java}     # Entry point
├── tcp/                         # TCP server implementation  
├── protocol/                    # JSON protocol handling
├── connection/                  # Connection management
└── config/                      # Configuration
```

First, implement a basic TCP server that can accept client connections. Your server should:

* **Bind to a configurable host and port** (default: localhost:5432)
* **Accept incoming connections** in a loop
* **Handle basic connection lifecycle** (connect, communicate, disconnect)
* **Log connection events** for debugging

Start with this server interface:

```bash
# Start server with default settings
./server

# Start with custom configuration
./server --port 5432 --host 0.0.0.0
./server --config server.conf
./server --log-level debug
./server --max-connections 1000
```

Your main server loop should accept connections and handle them appropriately. For now, each connection can simply echo
back any received data to verify the networking works.

## Task 2: JSON Protocol Implementation

In this task, you will need to modify:

```
protocol/json.{rs,cpp,py,go,java}
protocol/messages.{rs,cpp,py,go,java}
```

Implement the JSON-based client-server communication protocol. Define the message formats for requests and responses:

### Request Message Format

```json
{
  "message_id": "uuid-for-request-tracking",
  "type": "query|connect|disconnect|ping",
  "sql": "SELECT * FROM users WHERE age > 25",
  "client_id": "optional_client_identifier",
  "session_id": "session_identifier",
  "options": {
    "timeout_ms": 30000,
    "format": "table|json|csv"
  }
}
```

### Response Message Format

```json
{
  "message_id": "matching_request_uuid",
  "status": "success|error|warning",
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
  "error": null,
  "metadata": {
    "rows_affected": 0,
    "execution_time_ms": 42,
    "columns": [
      {
        "name": "id",
        "type": "INTEGER"
      },
      {
        "name": "name",
        "type": "VARCHAR"
      },
      {
        "name": "age",
        "type": "INTEGER"
      }
    ]
  },
  "server_info": {
    "version": "1.0.0",
    "timestamp": "2023-10-01T12:00:00Z"
  }
}
```

Implement message parsing, validation, and generation. Handle malformed JSON gracefully and return appropriate error
responses.

## Task 3: Message Framing

In this task, you will need to modify:

```
protocol/framing.{rs,cpp,py,go,java}
```

TCP is a stream protocol, so you need to frame JSON messages properly. Implement length-prefixed message framing:

```
Message Format:
[4 bytes: message length in network byte order][N bytes: JSON message]

Example:
[0x00, 0x00, 0x00, 0x2A]["{"type":"query","sql":"SELECT 1"}"]
```

Your framing implementation should:

* **Write messages**: Prefix JSON with length header
* **Read messages**: Read length first, then exact message bytes
* **Handle partial reads**: TCP may deliver data in chunks
* **Validate length**: Prevent buffer overflow attacks
* **Handle network interruptions**: Graceful error recovery

This ensures that JSON messages are properly delimited in the TCP stream.

## Task 4: Concurrency Implementation

In this task, you will need to modify:

```
connection/manager.{rs,cpp,py,go,java}
connection/handler.{rs,cpp,py,go,java}
```

Choose and implement a concurrency model to handle multiple clients simultaneously:

### Option A: Thread-per-Client

```pseudocode
main_thread:
  while server_running:
    client_socket = accept_connection()
    spawn_thread(handle_client, client_socket)

handle_client(socket):
  while connection_active:
    request = read_json_message(socket)
    response = process_request(request)
    send_json_message(socket, response)
```

### Option B: Thread Pool

```pseudocode
main_thread:
  thread_pool = create_thread_pool(num_workers)
  while server_running:
    client_socket = accept_connection()
    thread_pool.submit(handle_client, client_socket)
```

### Option C: Async I/O (Language-dependent)

```pseudocode
async main():
  while server_running:
    client_socket = await accept_connection()
    spawn_task(handle_client_async, client_socket)
```

Implement proper synchronization to protect shared resources and prevent race conditions.

## Task 5: Connection Management

In this task, you will need to modify:

```
connection/lifecycle.{rs,cpp,py,go,java}
connection/limits.{rs,cpp,py,go,java}
```

Implement robust connection lifecycle management:

### Connection States

1. **CONNECTING**: Initial connection establishment
2. **AUTHENTICATED**: Optional authentication completed
3. **ACTIVE**: Processing requests and responses
4. **DISCONNECTING**: Graceful shutdown in progress
5. **CLOSED**: Connection terminated and cleaned up

### Connection Limits and Timeouts

```
Max Connections: 1000 (configurable)
Connection Timeout: 300 seconds (configurable)
Idle Timeout: 60 seconds (configurable)
Request Timeout: 30 seconds (configurable)
```

### Error Isolation

* One client's errors shouldn't affect others
* Failed connections should be cleaned up automatically
* Server should remain stable under client failures
* Resource leaks must be prevented

Implement connection tracking to monitor active connections and enforce limits.

## Task 6: Configuration System

In this task, you will need to modify:

```
config/server.{rs,cpp,py,go,java}
```

Support configuration from multiple sources with proper priority:

### Configuration File (server.conf)

```toml
[server]
host = "0.0.0.0"
port = 5432
max_connections = 1000
worker_threads = 8

[timeouts]
connection_timeout_sec = 300
idle_timeout_sec = 60
request_timeout_sec = 30

[logging]
level = "info"
format = "json"
file = "/var/log/server.log"
console = true
```

### Environment Variables

```bash
SERVER_HOST=0.0.0.0
SERVER_PORT=5432
SERVER_MAX_CONNECTIONS=1000
LOG_LEVEL=debug
```

The configuration should be validated at startup and applied consistently.

## Task 7: Logging and Monitoring

In this task, you will need to modify:

```
logging/structured.{rs,cpp,py,go,java}
monitoring/metrics.{rs,cpp,py,go,java}
```

Implement comprehensive structured logging:

### Log Levels

* **ERROR**: Critical errors requiring attention
* **WARN**: Non-critical issues and warnings
* **INFO**: General operational information
* **DEBUG**: Detailed debugging information

### Example Log Events

```json
{
  "timestamp": "2023-10-01T12:00:00.123Z",
  "level": "INFO",
  "component": "server",
  "event": "client_connected",
  "client_id": "127.0.0.1:54321",
  "message": "New client connection established"
}

{
  "timestamp": "2023-10-01T12:00:01.456Z",
  "level": "DEBUG",
  "component": "protocol",
  "event": "request_received",
  "client_id": "127.0.0.1:54321",
  "message_id": "550e8400-e29b-41d4-a716-446655440000",
  "request_type": "query"
}
```

### Metrics to Collect

* Active connection count
* Request processing times
* Error rates by type
* Memory and CPU usage
* Network I/O statistics

## Task 8: Integration with Phase 1 Client

In this task, you will need to modify:

```
Your Phase 1 client to connect to the server
```

Update your Phase 1 client to connect to the server instead of using mock responses:

* **Network connection**: Establish TCP connection to server
* **Protocol implementation**: Send JSON requests and parse responses
* **Error handling**: Handle network failures gracefully
* **Reconnection logic**: Attempt to reconnect on connection loss

This creates a complete client-server system where your client can communicate with your server.

## Testing Your Implementation

Run the Phase 2 tests to validate your implementation:

```bash
# Test server functionality
./tools/test-runner/run_tests.sh --phase 2 --implementation student-submissions/my-implementation

# Test concurrent connections
./tools/test-runner/run_tests.sh --phase 2 --test concurrent-clients

# Test protocol compliance  
./tools/test-runner/run_tests.sh --phase 2 --test json-protocol

# Test error handling
./tools/test-runner/run_tests.sh --phase 2 --test error-scenarios
```

## Performance Requirements

Your server should meet these performance criteria:

* **Concurrent connections**: Handle 100+ simultaneous clients
* **Message latency**: < 10ms processing time for simple requests
* **Connection establishment**: < 50ms for new connections
* **Memory efficiency**: Reasonable per-client memory usage
* **Graceful shutdown**: < 5 seconds shutdown time

## Test Your Understanding

* Why do we use JSON over TCP instead of HTTP for the protocol?
* How does message framing solve the TCP stream boundary problem?
* What are the trade-offs between thread-per-client vs thread pool vs async I/O?
* How do you prevent one client's errors from affecting other clients?
* Why is structured logging important for server applications?
* How do you handle clients that send malformed JSON or very large messages?
* What happens if a client connects but never sends any data?
* How do you ensure the server shuts down gracefully?

## Bonus Tasks

* **Authentication**: Implement basic client authentication
* **Rate limiting**: Prevent clients from overwhelming the server
* **Metrics endpoint**: HTTP endpoint for monitoring server health
* **Connection pooling**: Reuse connections efficiently
* **SSL/TLS support**: Encrypt client-server communication
* **Admin interface**: Commands for server management

## Language-Specific Tips

### Rust

```rust
// Use tokio for async networking
use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

// Use serde for JSON handling
use serde::{Deserialize, Serialize};

// Use tracing for structured logging
use tracing::{info, error, debug};
```

### C++

```cpp
// Use standard networking or boost::asio
#include <sys/socket.h>
#include <netinet/in.h>
// OR
#include <boost/asio.hpp>

// Use nlohmann/json for JSON
#include <nlohmann/json.hpp>

// Use spdlog for logging
#include <spdlog/spdlog.h>
```

### Go

```go
// Use standard net package
import "net"

// Use standard encoding/json
import "encoding/json"

// Use logrus for structured logging
import "github.com/sirupsen/logrus"
```

### Python

```python
# Use asyncio for async networking
import asyncio
import json

# Use structlog for structured logging
import structlog
```

### Java

```java
// Use NIO for networking

import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;

// Use Jackson for JSON
import com.fasterxml.jackson.databind.ObjectMapper;

// Use Logback for logging
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
```

## Common Pitfalls

* **Resource leaks**: Always clean up client connections and threads
* **Thread safety**: Protect shared data structures with proper synchronization
* **Error propagation**: Don't let client errors crash the server
* **Memory management**: Limit per-client memory usage to prevent DoS
* **Network byte order**: Use network byte order for message length
* **Partial reads/writes**: Handle TCP's stream nature correctly
* **Graceful shutdown**: Properly close all connections on server exit

Your Phase 2 server will be the communication backbone for the entire database system. Focus on reliability,
performance, and maintainability as this component needs to handle all client interactions efficiently!