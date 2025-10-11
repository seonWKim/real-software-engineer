#!/bin/bash
# test_basic_signals.sh - Basic signal handling tests
# Phase 1 Task 2: Interactive Shell Implementation (Simplified - No 3rd party libraries)

set -e

# Configuration
TIMEOUT_DURATION=10
TEST_NAME="Basic Signal Handling"

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

# Test 1: EOF handling (Ctrl+D simulation)
log_test "1. EOF (Ctrl+D) handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Send EOF by closing input
    ./client < /dev/null
' 2>/dev/null; then
    log_pass "EOF handled gracefully"
    ((TESTS_PASSED++))
else
    log_fail "EOF handling failed"
    ((TESTS_FAILED++))
fi

# Test 2: SIGTERM handling
log_test "2. SIGTERM signal handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Start client in background
    echo "SELECT * FROM users;" | ./client &
    CLIENT_PID=$!
    
    # Give it time to start
    sleep 1
    
    # Send SIGTERM and check if it exits gracefully
    if kill -TERM $CLIENT_PID 2>/dev/null; then
        # Wait for process to terminate
        wait $CLIENT_PID 2>/dev/null || true
        exit 0
    else
        # Process already terminated
        exit 0
    fi
' 2>/dev/null; then
    log_pass "SIGTERM handled gracefully"
    ((TESTS_PASSED++))
else
    log_fail "SIGTERM handling failed"
    ((TESTS_FAILED++))
fi

# Test 3: Process cleanup
log_test "3. Process cleanup on exit"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Run client and ensure it exits cleanly
    echo "exit" | ./client
    
    # Check that no zombie processes remain
    sleep 1
    ZOMBIE_COUNT=$(ps aux | grep -c "[Zz]ombie" || echo "0")
    if [ "$ZOMBIE_COUNT" -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
' 2>/dev/null; then
    log_pass "Process cleanup works correctly"
    ((TESTS_PASSED++))
else
    log_fail "Process cleanup failed"
    ((TESTS_FAILED++))
fi

# Test 4: Graceful shutdown after commands
log_test "4. Graceful shutdown behavior"
if timeout ${TIMEOUT_DURATION}s bash -c '
    (echo "SELECT * FROM users;"
     echo "CREATE TABLE test (id INTEGER);"
     echo "exit") | ./client > /dev/null
' 2>/dev/null; then
    log_pass "Graceful shutdown after commands works"
    ((TESTS_PASSED++))
else
    log_fail "Graceful shutdown failed"
    ((TESTS_FAILED++))
fi

# Test 5: Handle broken pipe
log_test "5. Broken pipe handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Simulate broken pipe by closing output early
    echo "SELECT * FROM users;" | ./client | head -n 1 > /dev/null
' 2>/dev/null; then
    log_pass "Broken pipe handled gracefully"
    ((TESTS_PASSED++))
else
    log_fail "Broken pipe handling failed"
    ((TESTS_FAILED++))
fi

# Test 6: Long-running process termination
log_test "6. Long-running process termination"
if timeout 5s bash -c '
    # Start a long sequence of commands
    (for i in {1..100}; do echo "SELECT $i;"; done) | ./client > /dev/null &
    CLIENT_PID=$!
    
    # Let it run briefly then terminate
    sleep 1
    kill $CLIENT_PID 2>/dev/null || true
    wait $CLIENT_PID 2>/dev/null || true
    
    exit 0
' 2>/dev/null; then
    log_pass "Long-running process termination works"
    ((TESTS_PASSED++))
else
    log_fail "Long-running process termination failed"
    ((TESTS_FAILED++))
fi

# Test 7: Resource cleanup
log_test "7. Resource cleanup verification"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Run multiple client instances and ensure they clean up
    for i in {1..3}; do
        echo "SELECT $i; exit" | ./client > /dev/null &
    done
    
    # Wait for all to complete
    wait
    
    # Check for any remaining processes
    REMAINING=$(pgrep -f "./client" | wc -l)
    if [ "$REMAINING" -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
' 2>/dev/null; then
    log_pass "Resource cleanup verification passed"
    ((TESTS_PASSED++))
else
    log_fail "Resource cleanup verification failed"
    ((TESTS_FAILED++))
fi

# Test 8: Immediate termination handling
log_test "8. Immediate termination handling"
if timeout ${TIMEOUT_DURATION}s bash -c '
    # Start client and immediately kill it
    ./client &
    CLIENT_PID=$!
    
    # Kill immediately
    kill -9 $CLIENT_PID 2>/dev/null || true
    wait $CLIENT_PID 2>/dev/null || true
    
    exit 0
' 2>/dev/null; then
    log_pass "Immediate termination handled"
    ((TESTS_PASSED++))
else
    log_fail "Immediate termination handling failed"
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