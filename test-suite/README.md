# Test Suite Documentation

This directory contains comprehensive test suites for validating database client implementations across all project phases. The test suite is designed to be language-agnostic and compatible with any implementation that follows the project specifications.

## 📁 Directory Structure

```
test-suite/
├── README.md                 # This documentation
├── phase1/                   # Phase 1: Client Development
│   ├── task1/                # CLI Structure tests (future)
│   ├── task2/                # Interactive Shell tests
│   │   ├── test_basic_interactive.sh
│   │   ├── test_input_handling.sh
│   │   └── test_basic_signals.sh
│   └── task3/                # Output Formatting tests (future)
├── phase2/                   # Phase 2: SQL Parser (future)
├── phase3/                   # Phase 3: Database Engine (future)
├── phase4/                   # Phase 4: Advanced Features (future)
├── integration/              # Cross-phase integration tests (future)
└── performance/              # Performance benchmarking tests (future)
```

## 🚀 Quick Start

### Running Individual Tests

```bash
# Set your implementation directory
export IMPLEMENTATION_DIR="reference-implementation/phase1/task2"

# Run a specific test
./test-suite/phase1/task2/test_basic_interactive.sh
```

### Running All Tests for a Task

```bash
# Run all Phase 1 Task 2 tests
IMPLEMENTATION_DIR="your-implementation-path" ./test-suite/phase1/task2/run_simplified_tests.sh
```

### Running Tests with Different Implementations

```bash
# Test the reference implementation
IMPLEMENTATION_DIR="reference-implementation/phase1/task2" ./test-suite/phase1/task2/test_basic_interactive.sh

# Test a student implementation
IMPLEMENTATION_DIR="student-submissions/alice-rust" ./test-suite/phase1/task2/test_basic_interactive.sh

# Test your own implementation
IMPLEMENTATION_DIR="my-implementation" ./test-suite/phase1/task2/test_basic_interactive.sh
```

## 📋 Test Categories

### Phase 1: Client Development

#### Task 2: Interactive Shell
- **test_basic_interactive.sh**: Core interactive functionality (prompt, commands, exit handling)
- **test_input_handling.sh**: SQL input processing (multi-line, quotes, special characters)  
- **test_basic_signals.sh**: Signal handling and process cleanup (EOF, SIGTERM)

#### Future Tasks
- **Task 1**: CLI Structure and argument parsing
- **Task 3**: Output formatting and presentation
- **Task 4**: Command-line arguments and options
- **Task 5**: Configuration file handling
- **Task 6**: Error handling and reporting

### Future Phases
- **Phase 2**: SQL Parser validation
- **Phase 3**: Database engine correctness
- **Phase 4**: Advanced features and optimizations
- **Integration**: End-to-end workflow testing
- **Performance**: Benchmarking and load testing

## ⚙️ Test Execution Patterns

### Environment Variables

All tests support these standard environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `IMPLEMENTATION_DIR` | Path to implementation directory | `student-submissions/my-implementation` |
| `TIMEOUT_DURATION` | Test timeout in seconds | `10` |
| `VERBOSE` | Enable verbose output | `false` |

### Implementation Requirements

Your implementation directory must contain:

```
your-implementation/
├── client                    # Executable binary (required)
├── src/                      # Source code (optional)
├── Cargo.toml               # Project files (optional)
└── README.md                # Documentation (optional)
```

**Critical**: The `client` executable must be directly executable from the implementation directory.

### Test Script Conventions

All test scripts follow these patterns:

#### 1. **Standard Headers**
```bash
#!/bin/bash
set -e

# Configuration
TIMEOUT_DURATION=10
TEST_NAME="Test Category Name"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
```

#### 2. **Helper Functions**
```bash
log_test() { echo -e "${YELLOW}[TEST]${NC} $1"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; }
```

#### 3. **Implementation Discovery**
```bash
IMPLEMENTATION_DIR="${IMPLEMENTATION_DIR:-student-submissions/my-implementation}"
CLIENT_PATH="$IMPLEMENTATION_DIR/client"

if [ ! -x "$CLIENT_PATH" ]; then
    log_fail "Client executable not found at $CLIENT_PATH"
    exit 1
fi
```

#### 4. **Test Execution Pattern**
```bash
TESTS_PASSED=0
TESTS_FAILED=0

log_test "1. Test description"
if timeout ${TIMEOUT_DURATION}s bash -c 'test command here'; then
    log_pass "Test passed description"
    ((TESTS_PASSED++))
else
    log_fail "Test failed description"
    ((TESTS_FAILED++))
fi
```

#### 5. **Results Summary**
```bash
echo ""
echo "=== $TEST_NAME Test Results ==="
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"
echo "Total:  $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All $TEST_NAME tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some $TEST_NAME tests failed.${NC}"
    exit 1
fi
```

## 🎯 Test Design Principles

### 1. **Language Agnostic**
- Tests only interact with the `client` executable
- No assumptions about implementation language
- Standard input/output communication only

### 2. **Cross-Platform Compatible**
- Uses standard Unix tools (`bash`, `timeout`, `grep`)
- No third-party dependencies required
- Works on Linux, macOS, and Unix systems

### 3. **Timeout Protected**
- All tests have reasonable timeouts
- Prevents hanging on infinite loops
- Configurable timeout durations

### 4. **Comprehensive Coverage**
- Tests core functionality thoroughly
- Includes edge cases and error conditions
- Validates both positive and negative scenarios

### 5. **Clear Output**
- Colored output for easy result identification
- Detailed pass/fail reasons
- Summary statistics

## 🔧 Creating New Tests

### Adding Tests to Existing Tasks

1. **Create test script**: `test_new_feature.sh`
2. **Follow naming convention**: `test_<feature>_<aspect>.sh`
3. **Use standard patterns**: Copy existing test structure
4. **Update test runner**: Add to `run_simplified_tests.sh` if available

### Adding New Tasks

1. **Create directory**: `test-suite/phase1/task3/`
2. **Create test scripts**: Following naming conventions
3. **Create test runner**: `run_all_tests.sh` or `run_simplified_tests.sh`
4. **Document in README**: Add to this documentation

### Adding New Phases

1. **Create directory**: `test-suite/phase2/`
2. **Follow phase structure**: Maintain consistency with phase1
3. **Update this README**: Document new phase patterns

## 🐛 Debugging Failed Tests

### Common Issues

#### 1. **Client Not Found**
```
❌ Client executable not found at path/client
```
**Solutions:**
- Verify `IMPLEMENTATION_DIR` is correct
- Ensure `client` executable exists and is executable (`chmod +x client`)
- Check build process completed successfully

#### 2. **Tests Timeout**
```
❌ Test timed out
```
**Solutions:**
- Check for infinite loops in client
- Verify client handles EOF properly
- Increase `TIMEOUT_DURATION` if needed

#### 3. **Unexpected Output**
```
❌ Expected output not found
```
**Solutions:**
- Run client manually to see actual output
- Check prompt format (should be exactly `sql>`)
- Verify mock response format matches expected patterns

### Debug Mode

Run tests with verbose debugging:

```bash
# Enable bash debugging
bash -x ./test-suite/phase1/task2/test_basic_interactive.sh

# Run with custom timeout
TIMEOUT_DURATION=30 ./test-suite/phase1/task2/test_basic_interactive.sh

# Test manually
echo "SELECT * FROM users; exit" | ./your-implementation/client
```

## 📊 Test Results Interpretation

### Exit Codes
- `0`: All tests passed
- `1`: Some tests failed
- `124`: Test timed out (from `timeout` command)

### Status Types
- **PASS** ✅: Feature implemented correctly
- **FAIL** ❌: Feature has issues that need fixing
- **SKIP** ⚠️: Feature not implemented (rare, mostly for optional features)

### Success Criteria

#### Minimum Requirements (Must Pass)
Core functionality tests that are required for the task to be considered complete.

#### Full Implementation (Recommended) 
Additional tests that demonstrate a complete, robust implementation.

## 🚀 Integration with Build System

### Using with Reference Implementation

```bash
# Build and test in one command
make build PATH=phase1/task2 && IMPLEMENTATION_DIR="reference-implementation/phase1/task2" ./test-suite/phase1/task2/test_basic_interactive.sh
```

### Continuous Integration

```bash
#!/bin/bash
# ci-test.sh - Example CI script

set -e

echo "Building implementation..."
make build PATH=phase1/task2

echo "Running tests..."
export IMPLEMENTATION_DIR="reference-implementation/phase1/task2"

# Run all available tests
for test_script in ./test-suite/phase1/task2/test_*.sh; do
    echo "Running $(basename "$test_script")..."
    "$test_script"
done

echo "All tests passed! ✅"
```

## 🔄 Future Enhancements

### Planned Features
- **Test Coverage Reports**: Automated coverage analysis
- **Performance Benchmarking**: Standardized performance tests
- **Parallel Test Execution**: Run multiple tests concurrently
- **Test Result Aggregation**: Combined reporting across phases
- **Docker Integration**: Containerized test environments

### Contributing
When adding new tests, please:
1. Follow existing patterns and conventions
2. Include comprehensive documentation
3. Test with multiple implementation languages
4. Update this README with new patterns or requirements

---

## 📞 Support

For questions about test failures, implementation requirements, or adding new tests:

1. **Check this README** for common patterns and solutions
2. **Examine existing tests** for implementation examples  
3. **Test manually** to understand expected behavior
4. **Review project documentation** for specification details

The test suite is designed to be your definitive guide for implementation requirements. If a test passes, your implementation meets the specification for that feature! 🎉