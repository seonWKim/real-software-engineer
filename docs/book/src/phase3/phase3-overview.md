# Phase 3 Overview: SQL Processing Engine

![Phase 3 Overview](./images/phase3-overview.svg)

In the third phase of the project, you will build the **SQL processing engine** - the "brain" of your database system.
This is where SQL intelligence finally enters the system. Unlike the previous phases which handled user interface and
networking, Phase 3 implements the core database functionality that understands and executes SQL commands.

## Learning Objectives

By completing Phase 3, you will gain practical experience in:

- **Language Processing**: Lexical analysis, parsing, and AST construction
- **Compiler Design**: Building interpreters for domain-specific languages
- **Type Systems**: Implementing SQL data types with proper semantics
- **Query Processing**: Algorithm implementation for database operations
- **Data Structures**: Efficient in-memory storage and indexing
- **Expression Evaluation**: Recursive evaluation of complex expressions

## What You'll Build

### Core Features

- **SQL Lexer**: Tokenize SQL text into meaningful symbols
- **SQL Parser**: Build Abstract Syntax Trees from token streams
- **Type System**: Support INTEGER, VARCHAR, BOOLEAN, DECIMAL with NULL handling
- **Query Executor**: Execute parsed SQL on in-memory data structures
- **DDL Support**: CREATE TABLE, DROP TABLE, ALTER TABLE operations
- **DML Support**: SELECT, INSERT, UPDATE, DELETE with complex WHERE clauses
- **Expression Engine**: Evaluate arithmetic, logical, and comparison expressions
- **Aggregate Functions**: COUNT, SUM, AVG, MIN, MAX operations

### Database Engine Architecture

```
database/
├── lexer/
│   ├── tokenizer.{ext}       # SQL tokenization engine
│   ├── tokens.{ext}          # Token type definitions
│   └── keywords.{ext}        # SQL keyword recognition
├── parser/
│   ├── grammar.{ext}         # Recursive descent parser
│   ├── ast.{ext}             # Abstract syntax tree definitions
│   └── expressions.{ext}     # Expression parsing and precedence
├── types/
│   ├── value.{ext}           # SQL value representation
│   ├── schema.{ext}          # Table and column schemas
│   └── conversion.{ext}      # Type conversion and coercion
├── storage/
│   ├── memory/               # In-memory storage implementation
│   ├── table.{ext}           # Table management
│   └── row.{ext}             # Row storage and access
├── executor/
│   ├── engine.{ext}          # Main query execution engine
│   ├── operators/            # Query execution operators
│   │   ├── scan.{ext}        # Table scanning
│   │   ├── filter.{ext}      # WHERE clause filtering
│   │   ├── project.{ext}     # Column projection (SELECT)
│   │   ├── join.{ext}        # Table joins
│   │   ├── sort.{ext}        # ORDER BY sorting
│   │   └── aggregate.{ext}   # GROUP BY and aggregation
│   └── planner.{ext}         # Query planning and optimization
└── integration/
    └── server.{ext}          # Integration with Phase 2 server
```

## Task Breakdown

### Task 1: SQL Lexer (Tokenization)

Build a lexer that breaks SQL text into tokens: keywords, identifiers, literals, operators, and punctuation.

### Task 2: SQL Parser (AST Construction)

Implement a recursive descent parser that transforms token streams into Abstract Syntax Trees representing SQL
statements.

### Task 3: Type System

Create a comprehensive type system supporting SQL data types with proper NULL handling and three-valued logic.

### Task 4: In-Memory Storage

Implement efficient in-memory data structures for storing tables, rows, and maintaining schemas.

### Task 5: Query Execution Engine

Build the execution engine with operators for scanning, filtering, projection, joining, and aggregation.

### Task 6: DDL Operations

Implement Data Definition Language operations for creating, dropping, and altering tables.

### Task 7: Server Integration

Integrate the SQL engine with your Phase 2 server to create a complete client-server-database system.

## The SQL Intelligence Starts Here

**🧠 From Strings to Intelligence**

Phase 3 is where your system gains **SQL intelligence**:

- **Phase 1 Client**: Treats SQL as opaque strings
- **Phase 2 Server**: Routes SQL strings without understanding
- **Phase 3 Database**: **Understands SQL semantics and executes queries**

This is the first component that actually "knows" what `SELECT * FROM users WHERE age > 25` means!

## SQL Grammar Subset

Your Phase 3 implementation will support this SQL subset:

### Data Definition Language (DDL)

```sql
CREATE TABLE table_name (
    column_name data_type [NOT NULL] [PRIMARY KEY],
    ...
);

DROP TABLE [IF EXISTS] table_name;

ALTER TABLE table_name ADD COLUMN column_name data_type;
```

### Data Manipulation Language (DML)

```sql
SELECT [DISTINCT] column_list 
FROM table_name [alias]
[JOIN table_name ON condition]
[WHERE condition]
[GROUP BY column_list]
[HAVING condition]
[ORDER BY column_list [ASC|DESC]]
[LIMIT number [OFFSET number]];

INSERT INTO table_name [(column_list)] VALUES (value_list);

UPDATE table_name SET column = value [WHERE condition];

DELETE FROM table_name [WHERE condition];
```

### Expression Support

- **Arithmetic**: `+`, `-`, `*`, `/`, `%`
- **Comparison**: `=`, `<>`, `!=`, `<`, `<=`, `>`, `>=`
- **Logical**: `AND`, `OR`, `NOT`
- **Functions**: `COUNT(*)`, `SUM(col)`, `AVG(col)`, `MIN(col)`, `MAX(col)`
- **Literals**: Strings, integers, decimals, booleans, NULL

## Success Criteria

### Functionality

- ✅ Parses all supported SQL constructs correctly
- ✅ Executes queries and returns correct results
- ✅ Handles all data types with proper NULL semantics
- ✅ Supports complex WHERE clauses and expressions
- ✅ Implements JOIN operations correctly
- ✅ Handles DDL operations (CREATE, DROP, ALTER)

### Performance

- ✅ Parse time < 10ms for typical SQL statements
- ✅ Simple queries < 10ms execution on 1K records
- ✅ Complex queries < 100ms execution on 10K records
- ✅ Memory-efficient query execution
- ✅ Supports concurrent query execution

### Correctness

- ✅ SQL standard compliance for supported features
- ✅ Proper error handling with meaningful messages
- ✅ Consistent NULL handling across all operations
- ✅ Type safety and coercion rules
- ✅ Transaction-safe operations (foundation for Phase 5)

## Performance Requirements

| Component | Operation | Target | Dataset |
|-----------|-----------|--------|---------|
| Lexer | Tokenization | < 1ms | Typical SQL statement |
| Parser | AST construction | < 5ms | Complex SELECT query |
| Executor | Simple SELECT | < 10ms | 1K records |
| Executor | Complex JOIN | < 100ms | 10K records |
| Executor | Aggregation | < 50ms | 10K records |
| DDL | CREATE TABLE | < 1ms | Schema operation |

## Testing Strategy

### Unit Tests

- **Lexer**: Token recognition and error handling
- **Parser**: AST construction for all SQL constructs
- **Type System**: Value operations and conversions
- **Operators**: Individual execution operator correctness
- **Expressions**: Complex expression evaluation

### Integration Tests

- **End-to-End SQL**: Complete SQL statement execution
- **Schema Operations**: DDL statement execution
- **Data Manipulation**: DML statement correctness
- **Error Handling**: Invalid SQL and runtime errors

### Correctness Tests

- **SQL Compliance**: Standard SQL behavior verification
- **NULL Handling**: Three-valued logic correctness
- **Type Coercion**: Implicit conversion behavior
- **Edge Cases**: Boundary conditions and corner cases

### Performance Tests

- **Query Execution**: Performance across dataset sizes
- **Memory Usage**: Memory efficiency during execution
- **Concurrency**: Multiple simultaneous queries
- **Scalability**: Performance with growing data

## Integration with Previous Phases

### Server Integration Flow

```rust
// Phase 2 Server forwards to Phase 3 Database
impl ServerHandler {
    fn handle_request(&self, request: JsonRequest) -> JsonResponse {
        // Extract raw SQL from client request
        let sql = request.sql;
        
        // Forward to database engine (Phase 3)
        match self.database_engine.execute_sql(&sql) {
            Ok(result) => JsonResponse::success(result),
            Err(error) => JsonResponse::error(error.to_string()),
        }
    }
}

// Phase 3 Database Engine
impl DatabaseEngine {
    fn execute_sql(&self, sql: &str) -> Result<QueryResult> {
        // 1. Tokenize SQL
        let tokens = self.lexer.tokenize(sql)?;
        
        // 2. Parse into AST
        let ast = self.parser.parse(tokens)?;
        
        // 3. Execute query
        let result = self.executor.execute(ast)?;
        
        Ok(result)
    }
}
```

## Preparation for Phase 4

Your Phase 3 implementation should be designed for Phase 4 storage integration:

- **Storage Abstraction**: Design storage interfaces that can swap from memory to disk
- **Query Planning**: Build foundation for query optimization
- **Index Awareness**: Prepare for index-based query execution
- **Transaction Foundation**: Design for future transaction support

## Common Challenges

**⚠️ Common Pitfalls:**

- **Parser Complexity**: Start with simple grammar, add features incrementally
- **Error Handling**: Provide clear error messages with source locations
- **Memory Management**: Be careful with recursive AST structures
- **Type System**: Handle NULL values correctly in all operations
- **Expression Evaluation**: Watch out for operator precedence bugs
- **Performance**: Avoid quadratic algorithms for large datasets
- **SQL Compliance**: Test against standard SQL behavior expectations

## Language-Specific Considerations

### Rust

- Use `nom` or `pest` for parsing, `rust_decimal` for decimal arithmetic
- Leverage `enum` types for AST nodes and `Result` for error handling
- Consider `HashMap` for efficient table and column lookups

### C++

- Use `std::variant` for value types and `std::optional` for NULL handling
- Implement careful memory management for AST nodes
- Use `std::unordered_map` for fast table and schema lookups

### Go

- Use `interface{}` for value types with type assertions
- Leverage goroutines for concurrent query execution
- Use `map[string]interface{}` for flexible data structures

### Python

- Use `typing` for type hints and `dataclasses` for structured data
- Leverage built-in `re` module for tokenization
- Use `pandas` for advanced data manipulation (optional)

### Java

- Use generic types and `Optional` for NULL handling
- Leverage `HashMap` and collections framework
- Consider visitor pattern for AST traversal

## Ready to Start?

Phase 3 is where your database system becomes truly intelligent. You'll implement the core algorithms that power SQL
databases and gain deep understanding of how query processing works.

**Next**: Begin with [Task 1: SQL Lexer](./phase3-01-lexer.md) to start building your SQL processing engine.