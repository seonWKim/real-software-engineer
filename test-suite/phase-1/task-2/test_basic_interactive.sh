#!/bin/bash
# test_basic_interactive.sh - Basic interactive shell functionality tests
# Phase 1 Task 2: Interactive Shell Implementation (Simplified - No 3rd party libraries)

set -e

# Configuration
TIMEOUT_DURATION=10
TEST_NAME="Basic Interactive Shell"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_test() {
    echo -e "${YELLOW}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Get implementation directory from environment or default
IMPLEMENTATION_DIR="${IMPLEMENTATION_DIR:-student-submissions/my-implementation}"
CLIENT_PATH="$IMPLEMENTATION_DIR/client"

echo "=== Phase 1 Task 2: $TEST_NAME Tests ==="

# Verify client exists
if [ ! -x "$CLIENT_PATH" ]; then
    log_fail "Client executable not found at $CLIENT_PATH"
    exit 1
fi

cd "$IMPLEMENTATION_DIR"

TESTS_PASSED=0
TESTS_FAILED=0

# Test 1: Basic interactive mode startup
log_test "1. Interactive mode starts and shows prompt"
if timeout ${TIMEOUT_DURATION}s bash -c '
    echo "exit" | ./client | grep -q "sql>"
' 2>/dev/null; then
    log_pass "Interactive prompt displayed"
    ((TESTS_PASSED++))
else
    log_fail "No interactive prompt found"
    ((TESTS_FAILED++))
fi

# Test 2: Simple SQL command execution
log_test "2. SQL command execution"
if timeout ${TIMEOUT_DURATION}s bash -c '
    echo -e "SELECT * FROM users;\nexit" | ./client | grep -q -E "(Alice|users|rows)"
' 2>/dev/null; then
    log_pass "SQL command execution works"
    ((TESTS_PASSED++))
else
    log_fail "SQL command execution failed"
    ((TESTS_FAILED++))
fi

# Test 3: Multiple SQL commands
log_test "3. Multiple SQL commands"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users;"
     echo "CREATE TABLE test (id INTEGER);"
     echo "INSERT INTO test VALUES (1);"
     echo "exit") | ./client | grep -q -E "(Alice|created|inserted)"
' 2>/dev/null; then
    log_pass "Multiple SQL commands work"
    ((TESTS_PASSED++))
else
    log_fail "Multiple SQL commands failed"
    ((TESTS_FAILED++))
fi

# Test 4: Empty line handling
log_test "4. Empty line handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo ""
     echo "   "
     echo "SELECT 1;"
     echo "exit") | ./client | grep -q "sql>"
' 2>/dev/null; then
    log_pass "Empty lines handled gracefully"
    ((TESTS_PASSED++))
else
    log_fail "Empty line handling failed"
    ((TESTS_FAILED++))
fi

# Test 5: Exit command
log_test "5. Exit command functionality"
if timeout ${TIMEOUT_DURATION}s bash -c '
    echo "exit" | ./client
' 2>/dev/null; then
    log_pass "Exit command works"
    ((TESTS_PASSED++))
else
    log_fail "Exit command failed"
    ((TESTS_FAILED++))
fi

# Test 6: Quit command alternative
log_test "6. Quit command alternative"
if timeout ${TIMEOUT_DURATION}s bash -c '
    echo "quit" | ./client
' 2>/dev/null; then
    log_pass "Quit command works"
    ((TESTS_PASSED++))
else
    log_fail "Quit command failed"
    ((TESTS_FAILED++))
fi

# Test 7: Case insensitive exit
log_test "7. Case insensitive exit commands"
if timeout ${TIMEOUT_DURATION}s bash -c '
    echo "EXIT" | ./client
' 2>/dev/null; then
    log_pass "Case insensitive exit works"
    ((TESTS_PASSED++))
else
    log_fail "Case insensitive exit failed"
    ((TESTS_FAILED++))
fi

# Test 8: SQL with semicolon
log_test "8. SQL commands with semicolons"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users;"
     echo "exit") | ./client | grep -q -E "(Alice|users)"
' 2>/dev/null; then
    log_pass "SQL with semicolons works"
    ((TESTS_PASSED++))
else
    log_fail "SQL with semicolons failed"
    ((TESTS_FAILED++))
fi

# Test 9: SQL without semicolon
log_test "9. SQL commands without semicolons"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users"
     echo "exit") | ./client | grep -q -E "(Alice|users)"
' 2>/dev/null; then
    log_pass "SQL without semicolons works"
    ((TESTS_PASSED++))
else
    log_fail "SQL without semicolons failed"
    ((TESTS_FAILED++))
fi

# Test 10: Basic error handling
log_test "10. Invalid SQL handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "INVALID SQL COMMAND;"
     echo "SELECT * FROM users;"
     echo "exit") | ./client | grep -q -E "(Alice|users|error|invalid)"
' 2>/dev/null; then
    log_pass "Invalid SQL handled appropriately"
    ((TESTS_PASSED++))
else
    log_fail "Invalid SQL handling failed"
    ((TESTS_FAILED++))
fi

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