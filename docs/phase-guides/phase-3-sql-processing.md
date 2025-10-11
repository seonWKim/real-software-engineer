# Phase 3: SQL Processing

In this phase, you will:

* Implement a SQL lexer to tokenize SQL statements
* Build a recursive descent parser to create Abstract Syntax Trees (ASTs)
* Create a type system supporting INTEGER, VARCHAR, BOOLEAN, DECIMAL
* Implement a query execution engine with in-memory storage

To copy the test cases and run them,

```
./tools/test-runner/run_tests.sh --phase 3 --implementation student-submissions/my-implementation
```

## Task 1: SQL Lexer (Tokenization)

In this task, you will need to create:

```
database/
├── lexer/
│   ├── tokenizer.{rs,cpp,py,go,java}
│   ├── tokens.{rs,cpp,py,go,java}
│   └── keywords.{rs,cpp,py,go,java}
├── parser/
├── executor/
└── storage/
```

First, implement a SQL lexer that breaks SQL text into tokens. Your lexer should recognize:

### Token Types

* **Keywords**: SELECT, FROM, WHERE, INSERT, UPDATE, DELETE, CREATE, DROP, etc.
* **Identifiers**: Table names, column names (case-insensitive)
* **Literals**:
    * String literals: `'hello world'`, `'can''t'` (escaped single quotes)
    * Integer literals: `123`, `-456`
    * Decimal literals: `123.45`, `.5`, `5.`, `1.23e-4`
    * Boolean literals: `TRUE`, `FALSE`
    * NULL literal: `NULL`
* **Operators**: `=`, `<>`, `!=`, `<`, `<=`, `>`, `>=`, `+`, `-`, `*`, `/`, `%`
* **Logical operators**: `AND`, `OR`, `NOT`
* **Punctuation**: `,`, `;`, `(`, `)`, `[`, `]`
* **Whitespace**: Spaces, tabs, newlines (usually ignored)
* **Comments**: `-- single line` and `/* multi line */`

### Example Tokenization

```sql
SELECT name, age
FROM users
WHERE age > 25;
```

Should produce tokens:

```
[KEYWORD(SELECT), IDENTIFIER(name), COMMA, IDENTIFIER(age), KEYWORD(FROM), 
 IDENTIFIER(users), KEYWORD(WHERE), IDENTIFIER(age), GT, INTEGER(25), SEMICOLON]
```

Implement error handling for invalid tokens and provide helpful error messages with line and column positions.

## Task 2: SQL Parser (AST Construction)

In this task, you will need to modify:

```
parser/grammar.{rs,cpp,py,go,java}
parser/ast.{rs,cpp,py,go,java}
parser/expressions.{rs,cpp,py,go,java}
```

Implement a recursive descent parser that builds Abstract Syntax Trees from tokens. Support this SQL grammar subset:

### Data Definition Language (DDL)

```sql
CREATE TABLE table_name
(
    column_name data_type [NOT NULL] [PRIMARY KEY], .
    .
    .
);

DROP TABLE [IF EXISTS] table_name;

ALTER TABLE table_name
    ADD COLUMN column_name data_type;
```

### Data Manipulation Language (DML)

```sql
SELECT [DISTINCT] column_list
FROM table_name [alias]
    [JOIN table_name
ON condition]
    [
WHERE condition]
    [
GROUP BY column_list]
    [
HAVING condition]
    [
ORDER BY column_list [ASC | DESC]]
    [LIMIT number [
OFFSET number]];

INSERT INTO table_name [(column_list)]
VALUES (value_list);

UPDATE table_name
SET column = value [
WHERE condition];

DELETE
FROM table_name [
WHERE condition];
```

### AST Node Types

Design AST nodes to represent SQL constructs:

```rust
// Example AST structure (adapt to your language)
enum Statement {
    Select(SelectStatement),
    Insert(InsertStatement),
    Update(UpdateStatement),
    Delete(DeleteStatement),
    CreateTable(CreateTableStatement),
    DropTable(DropTableStatement),
}

struct SelectStatement {
    distinct: bool,
    columns: Vec<SelectColumn>,
    from: Option<TableReference>,
    joins: Vec<Join>,
    where_clause: Option<Expression>,
    group_by: Vec<Expression>,
    having: Option<Expression>,
    order_by: Vec<OrderByClause>,
    limit: Option<u64>,
    offset: Option<u64>,
}

enum Expression {
    Column(String),
    Literal(Literal),
    BinaryOp { op: BinaryOperator, left: Box<Expression>, right: Box<Expression> },
    Function { name: String, args: Vec<Expression> },
}
```

Implement proper operator precedence and associativity for expressions.

## Task 3: Type System

In this task, you will need to modify:

```
database/types/
├── value.{rs,cpp,py,go,java}
├── schema.{rs,cpp,py,go,java}
└── conversion.{rs,cpp,py,go,java}
```

Implement a type system supporting these SQL data types:

### Supported Data Types

* **INTEGER**: 32-bit signed integer
* **VARCHAR(n)**: Variable-length string up to n characters
* **BOOLEAN**: True/false/null
* **DECIMAL(p,s)**: Fixed-point decimal with precision p and scale s

### Value Representation

```rust
// Example value representation
enum Value {
    Integer(i32),
    String(String),
    Boolean(bool),
    Decimal(BigDecimal), // or your language's decimal type
    Null,
}
```

### Type Operations

* **Type checking**: Ensure operations are valid for given types
* **Type coercion**: Automatic conversion between compatible types
* **Null handling**: Three-valued logic (true/false/null) for all operations
* **Comparison**: Implement comparison operators for all types
* **Arithmetic**: Basic math operations where applicable

## Task 4: In-Memory Storage

In this task, you will need to modify:

```
storage/memory/
├── table.{rs,cpp,py,go,java}
├── row.{rs,cpp,py,go,java}
└── schema.{rs,cpp,py,go,java}
```

Implement in-memory storage structures for tables and rows:

### Table Schema

```rust
struct TableSchema {
    name: String,
    columns: Vec<ColumnDefinition>,
    primary_key: Option<String>,
}

struct ColumnDefinition {
    name: String,
    data_type: DataType,
    not_null: bool,
    default_value: Option<Value>,
}
```

### Row Storage

```rust
struct Table {
    schema: TableSchema,
    rows: Vec<Row>,
    indexes: HashMap<String, Index>, // For future optimization
}

struct Row {
    values: Vec<Value>, // Ordered by column definition
}
```

Use efficient data structures:

* **HashMap** for table lookup by name
* **Vec** for row storage within tables
* **HashMap** for fast column access by name

## Task 5: Query Execution Engine

In this task, you will need to modify:

```
executor/
├── engine.{rs,cpp,py,go,java}
├── operators/
│   ├── scan.{rs,cpp,py,go,java}
│   ├── filter.{rs,cpp,py,go,java}
│   ├── project.{rs,cpp,py,go,java}
│   ├── join.{rs,cpp,py,go,java}
│   ├── sort.{rs,cpp,py,go,java}
│   └── aggregate.{rs,cpp,py,go,java}
└── planner.{rs,cpp,py,go,java}
```

Implement a query execution engine that can execute parsed SQL statements:

### Execution Operators

* **TableScan**: Read all rows from a table
* **Filter**: Apply WHERE clause predicates
* **Project**: Select specific columns (SELECT clause)
* **Join**: Inner join between tables
* **Sort**: ORDER BY implementation
* **Limit**: LIMIT/OFFSET implementation
* **Aggregate**: GROUP BY and aggregate functions (COUNT, SUM, AVG, MIN, MAX)

### Execution Strategy

```rust
// Example execution pipeline
fn execute_select(stmt: &SelectStatement) -> Result<ResultSet> {
    let mut pipeline = TableScan::new(&stmt.from);

    if let Some(condition) = &stmt.where_clause {
        pipeline = Filter::new(pipeline, condition);
    }

    pipeline = Project::new(pipeline, &stmt.columns);

    if !stmt.order_by.is_empty() {
        pipeline = Sort::new(pipeline, &stmt.order_by);
    }

    if let Some(limit) = stmt.limit {
        pipeline = Limit::new(pipeline, limit, stmt.offset);
    }

    pipeline.execute()
}
```

### Expression Evaluation

Implement recursive expression evaluation:

```rust
fn evaluate_expression(expr: &Expression, row: &Row, schema: &TableSchema) -> Value {
    match expr {
        Expression::Column(name) => row.get_column(name, schema),
        Expression::Literal(lit) => lit.clone(),
        Expression::BinaryOp { op, left, right } => {
            let left_val = evaluate_expression(left, row, schema);
            let right_val = evaluate_expression(right, row, schema);
            apply_binary_operator(op, left_val, right_val)
        }
        Expression::Function { name, args } => {
            evaluate_function(name, args, row, schema)
        }
    }
}
```

## Task 6: DDL Operations

In this task, you will need to modify:

```
executor/ddl.{rs,cpp,py,go,java}
```

Implement Data Definition Language operations:

### CREATE TABLE

* Parse column definitions and constraints
* Validate data types and constraints
* Create table schema in metadata
* Initialize empty table structure

### DROP TABLE

* Validate table exists
* Handle IF EXISTS clause
* Remove table from metadata
* Clean up associated resources

### ALTER TABLE

* Support ADD COLUMN operations
* Validate new column definition
* Update existing table schema
* Handle default values for existing rows

## Task 7: Integration with Server

In this task, you will need to modify:

```
Your Phase 2 server to use the SQL engine
```

Integrate the SQL processing engine with your server:

* **Request handling**: Parse SQL from client JSON requests
* **Query execution**: Execute parsed queries using the engine
* **Result formatting**: Convert query results to JSON responses
* **Error handling**: Return SQL errors as JSON error responses
* **Metadata**: Include execution time and row counts in responses

Update your server's request processing to:

1. Parse SQL from the request
2. Execute the query using your SQL engine
3. Format results according to client preferences
4. Return JSON response with data and metadata

## Testing Your Implementation

Run the Phase 3 tests to validate your SQL processing:

```bash
# Test all SQL processing functionality
./tools/test-runner/run_tests.sh --phase 3 --implementation student-submissions/my-implementation

# Test specific SQL features
./tools/test-runner/run_tests.sh --phase 3 --test lexer-parser
./tools/test-runner/run_tests.sh --phase 3 --test query-execution
./tools/test-runner/run_tests.sh --phase 3 --test ddl-operations
./tools/test-runner/run_tests.sh --phase 3 --test data-types
```

## Performance Requirements

Your SQL engine should meet these performance criteria:

* **Parse time**: < 10ms for typical SQL statements
* **Simple queries**: < 10ms execution time on 1K records
* **Complex queries**: < 100ms execution time on 10K records
* **Memory usage**: Efficient memory management for query results
* **Concurrent queries**: Support multiple simultaneous queries

## Test Your Understanding

* Why do we separate lexing and parsing into two phases?
* How does operator precedence affect the AST structure?
* What are the trade-offs between different expression evaluation strategies?
* How do you handle NULL values in three-valued logic?
* Why is type coercion important in SQL systems?
* How would you optimize the performance of table scans?
* What are the memory implications of different join algorithms?
* How do you ensure consistent behavior with SQL standards?

## Bonus Tasks

* **Subqueries**: Support nested SELECT statements
* **Window functions**: ROW_NUMBER(), RANK(), etc.
* **More join types**: LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
* **Advanced aggregates**: DISTINCT in aggregate functions
* **Common Table Expressions (CTEs)**: WITH clause support
* **Prepared statements**: Parameter binding and reuse
* **Query optimization**: Basic cost-based optimization

## Language-Specific Tips

### Rust

```rust
// Use nom or pest for parsing
use nom::{IResult, bytes::complete::tag};

// Use rust_decimal for decimal arithmetic
use rust_decimal::Decimal;

// Use HashMap for efficient lookups
use std::collections::HashMap;
```

### C++

```cpp
// Use regex for tokenization
#include <regex>

// Use variant for values
#include <variant>
using Value = std::variant<int32_t, std::string, bool>;

// Use unordered_map for lookups
#include <unordered_map>
```

### Go

```go
// Use strings package for tokenization
import "strings"

// Use interface{} for values
type Value interface{}

// Use map for lookups
type Table map[string]interface{}
```

### Python

```python
# Use re module for tokenization
import re

# Use typing for type hints
from typing import Union, List, Dict

# Use dataclasses for structures
from dataclasses import dataclass
```

### Java

```java
// Use regular expressions

import java.util.regex.Pattern;

// Use generic types
public class Value<T> { ...
}

// Use HashMap for lookups
import java.util.HashMap;
```

## Common Pitfalls

* **Parser complexity**: Start with simple grammar, add features incrementally
* **Error handling**: Provide clear error messages with location information
* **Memory management**: Be careful with recursive AST structures
* **Type system**: Handle NULL values correctly in all operations
* **Expression evaluation**: Watch out for operator precedence bugs
* **Performance**: Avoid quadratic algorithms for large datasets
* **SQL compliance**: Test against standard SQL behavior

Your Phase 3 SQL engine forms the core intelligence of your database system. Focus on correctness first, then optimize
for performance as you add more complex query features!