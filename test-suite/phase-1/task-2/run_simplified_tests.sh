#!/bin/bash
# run_simplified_tests.sh - Simplified test runner for Phase 1 Task 2
# Interactive Shell Implementation (No 3rd party libraries required)

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMEOUT_DURATION=60  # 1 minute total timeout
TEST_NAME="Phase 1 Task 2 - Interactive Shell (Simplified)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Helper functions
log_header() {
    echo -e "${BLUE}${BOLD}$1${NC}"
    echo -e "${BLUE}$(printf '=%.0s' $(seq 1 ${#1}))${NC}"
}

log_section() {
    echo -e "\n${YELLOW}${BOLD}$1${NC}"
    echo -e "${YELLOW}$(printf '-%.0s' $(seq 1 ${#1}))${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Simplified test runner for Phase 1 Task 2 (No 3rd party libraries)"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -v, --verbose           Verbose output"
    echo "  -q, --quiet             Quiet mode"
    echo "  --implementation DIR    Implementation directory path"
    echo "  --test NAME             Run specific test (basic|input|signals)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Run all tests"
    echo "  $0 --test basic                       # Run only basic tests"
    echo "  $0 --implementation my-impl           # Custom implementation"
    echo ""
}

# Parse command line arguments
VERBOSE=false
QUIET=false
SPECIFIC_TEST=""
IMPLEMENTATION_DIR="student-submissions/my-implementation"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        --implementation)
            IMPLEMENTATION_DIR="$2"
            shift 2
            ;;
        --test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Start timer
START_TIME=$(date +%s)

log_header "$TEST_NAME Test Suite"

# Environment validation
log_section "Environment Validation"

# Resolve implementation directory path
if [ ! -d "$IMPLEMENTATION_DIR" ]; then
    # Try relative to project root
    PROJECT_ROOT=$(cd "$SCRIPT_DIR/../../../.." && pwd)
    if [ -d "$PROJECT_ROOT/$IMPLEMENTATION_DIR" ]; then
        IMPLEMENTATION_DIR="$PROJECT_ROOT/$IMPLEMENTATION_DIR"
    else
        log_fail "Implementation directory not found: $IMPLEMENTATION_DIR"
        exit 1
    fi
fi

CLIENT_PATH="$IMPLEMENTATION_DIR/client"

# Check if client exists
if [ ! -x "$CLIENT_PATH" ]; then
    log_fail "Client executable not found at $CLIENT_PATH"
    log_info "Please build your client first with basic terminal I/O support"
    exit 1
fi

log_pass "Client executable found at $CLIENT_PATH"

# Export implementation directory for test scripts
export IMPLEMENTATION_DIR

# Test suite definitions
declare -A TEST_SUITES=(
    ["basic"]="test_basic_interactive.sh"
    ["input"]="test_input_handling.sh" 
    ["signals"]="test_basic_signals.sh"
)

declare -A TEST_DESCRIPTIONS=(
    ["basic"]="Basic Interactive Shell"
    ["input"]="Input Handling"
    ["signals"]="Basic Signal Handling"
)

# Determine which tests to run
if [ -n "$SPECIFIC_TEST" ]; then
    if [[ ! -v TEST_SUITES["$SPECIFIC_TEST"] ]]; then
        log_fail "Unknown test: $SPECIFIC_TEST"
        log_info "Available tests: ${!TEST_SUITES[*]}"
        exit 1
    fi
    TESTS_TO_RUN=("$SPECIFIC_TEST")
else
    TESTS_TO_RUN=("basic" "input" "signals")
fi

# Test execution
log_section "Test Execution"

TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

for test_key in "${TESTS_TO_RUN[@]}"; do
    test_script="${TEST_SUITES[$test_key]}"
    test_description="${TEST_DESCRIPTIONS[$test_key]}"
    
    ((TOTAL_SUITES++))
    
    log_info "Running: $test_description"
    
    if [ ! -f "$SCRIPT_DIR/$test_script" ]; then
        log_fail "Test script not found: $test_script"
        ((FAILED_SUITES++))
        continue
    fi
    
    # Make script executable
    chmod +x "$SCRIPT_DIR/$test_script"
    
    # Run test with timeout
    if timeout ${TIMEOUT_DURATION}s bash "$SCRIPT_DIR/$test_script"; then
        log_pass "$test_description completed successfully"
        ((PASSED_SUITES++))
    else
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 124 ]; then
            log_fail "$test_description timed out"
        else
            log_fail "$test_description failed (exit code: $EXIT_CODE)"
        fi
        ((FAILED_SUITES++))
    fi
    
    echo ""  # Add spacing between test suites
done

# Calculate execution time
END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME - START_TIME))

# Test summary
log_section "Test Summary"

echo "Test Suite: $TEST_NAME"
echo "Implementation: $IMPLEMENTATION_DIR"
echo "Execution Time: ${EXECUTION_TIME}s"
echo ""
echo "Test Suites Results:"
echo "  Passed:  $PASSED_SUITES"
echo "  Failed:  $FAILED_SUITES"
echo "  Total:   $TOTAL_SUITES"

# Final result
echo ""
if [ $FAILED_SUITES -eq 0 ]; then
    log_pass "🎉 All simplified test suites passed!"
    echo ""
    echo "Your interactive shell successfully implements:"
    echo "  ✅ Basic interactive SQL prompt (sql>)"
    echo "  ✅ SQL command execution with mock responses"
    echo "  ✅ Input handling for various SQL formats"
    echo "  ✅ Basic signal handling and process cleanup"
    echo "  ✅ Exit/quit command functionality"
    echo ""
    echo "Implementation approach: Simple terminal I/O without 3rd party libraries"
    echo "This approach ensures cross-language compatibility!"
    echo ""
    echo "Ready to proceed to Task 3: Output Formatting!"
    exit 0
else
    log_fail "❌ Some test suites failed."
    echo ""
    echo "Please fix the failing tests. Focus on:"
    echo "  - Basic stdin/stdout handling"
    echo "  - Simple prompt display"
    echo "  - Command parsing and mock responses"
    echo "  - Clean process exit"
    exit 1
fi