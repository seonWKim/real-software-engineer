#!/bin/bash
# test_input_handling.sh - Input handling tests
# Phase 1 Task 2: Interactive Shell Implementation (Simplified - No 3rd party libraries)

set -e

# Configuration
TIMEOUT_DURATION=10
TEST_NAME="Input Handling"

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

# Test 1: Multi-line SQL statement (basic)
log_test "1. Multi-line SQL input"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT *"
     echo "FROM users"
     echo "WHERE age > 25;"
     echo "exit") | ./client | grep -q -E "(Alice|users)"
' 2>/dev/null; then
    log_pass "Multi-line SQL input works"
    ((TESTS_PASSED++))
else
    log_fail "Multi-line SQL input failed"
    ((TESTS_FAILED++))
fi

# Test 2: Long SQL command
log_test "2. Long SQL command handling"
LONG_SQL="SELECT id, name, age, email FROM users WHERE age > 25 AND name LIKE '%test%' ORDER BY age DESC;"
if timeout ${TIMEOUT_DURATION}s bash -c "
    (echo \"$LONG_SQL\"
     echo \"exit\") | ./client | grep -q -E \"(Alice|users|sql>)\"
" 2>/dev/null; then
    log_pass "Long SQL command handled"
    ((TESTS_PASSED++))
else
    log_fail "Long SQL command handling failed"
    ((TESTS_FAILED++))
fi

# Test 3: SQL with quotes
log_test "3. SQL with quoted strings"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT '\''Hello World'\'' as greeting;"
     echo "exit") | ./client | grep -q "sql>"
' 2>/dev/null; then
    log_pass "SQL with quotes handled"
    ((TESTS_PASSED++))
else
    log_fail "SQL with quotes failed"
    ((TESTS_FAILED++))
fi

# Test 4: SQL with special characters
log_test "4. SQL with special characters"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users WHERE email = '\''user@domain.com'\'';"
     echo "exit") | ./client | grep -q "sql>"
' 2>/dev/null; then
    log_pass "SQL with special characters handled"
    ((TESTS_PASSED++))
else
    log_fail "SQL with special characters failed"
    ((TESTS_FAILED++))
fi

# Test 5: SQL with numbers
log_test "5. SQL with numeric values"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users WHERE age = 25;"
     echo "INSERT INTO users VALUES (999, '\''Test'\'', 30, '\''test@example.com'\'');"
     echo "exit") | ./client | grep -q -E "(Alice|users|inserted)"
' 2>/dev/null; then
    log_pass "SQL with numbers handled"
    ((TESTS_PASSED++))
else
    log_fail "SQL with numbers failed"
    ((TESTS_FAILED++))
fi

# Test 6: Whitespace handling
log_test "6. Whitespace in SQL commands"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "   SELECT   *   FROM   users   ;"
     echo "exit") | ./client | grep -q -E "(Alice|users)"
' 2>/dev/null; then
    log_pass "Whitespace in SQL handled"
    ((TESTS_PASSED++))
else
    log_fail "Whitespace in SQL failed"
    ((TESTS_FAILED++))
fi

# Test 7: Comments in SQL (if supported)
log_test "7. SQL comments handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "-- This is a comment"
     echo "SELECT * FROM users; -- Another comment"
     echo "exit") | ./client | grep -q -E "(Alice|users|sql>)"
' 2>/dev/null; then
    log_pass "SQL comments handled (or ignored appropriately)"
    ((TESTS_PASSED++))
else
    log_fail "SQL comments handling failed"
    ((TESTS_FAILED++))
fi

# Test 8: Case insensitive SQL
log_test "8. Case insensitive SQL keywords"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "select * from users;"
     echo "SELECT * FROM USERS;"
     echo "Select * From Users;"
     echo "exit") | ./client | grep -q -E "(Alice|users)"
' 2>/dev/null; then
    log_pass "Case insensitive SQL works"
    ((TESTS_PASSED++))
else
    log_fail "Case insensitive SQL failed"
    ((TESTS_FAILED++))
fi

# Test 9: Mixed case table/column names
log_test "9. Mixed case identifiers"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "CREATE TABLE TestTable (Id INTEGER, Name VARCHAR(50));"
     echo "SELECT Name FROM TestTable;"
     echo "exit") | ./client | grep -q -E "(created|success|sql>)"
' 2>/dev/null; then
    log_pass "Mixed case identifiers handled"
    ((TESTS_PASSED++))
else
    log_fail "Mixed case identifiers failed"
    ((TESTS_FAILED++))
fi

# Test 10: Rapid command input
log_test "10. Rapid command sequence"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (for i in {1..5}; do echo "SELECT $i;"; done
     echo "exit") | ./client | grep -q "sql>"
' 2>/dev/null; then
    log_pass "Rapid command sequence handled"
    ((TESTS_PASSED++))
else
    log_fail "Rapid command sequence failed"
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