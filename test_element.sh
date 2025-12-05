#!/bin/bash

# Test script for element.sh
# This script runs basic tests to verify element.sh works correctly

TEST_COUNT=0
PASS_COUNT=0

# Helper function to run a test
run_test() {
  local test_name=$1
  local expected=$2
  local result=$3
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [[ "$result" == *"$expected"* ]]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "✓ Test $TEST_COUNT: $test_name - PASSED"
  else
    echo "✗ Test $TEST_COUNT: $test_name - FAILED"
    echo "  Expected: $expected"
    echo "  Got: $result"
  fi
}

echo "Running tests for element.sh..."
echo ""

# Test with no arguments
RESULT=$(./element.sh 2>&1)
run_test "No arguments provided" "Usage" "$RESULT"

# Test with invalid element
RESULT=$(./element.sh "Xyz" 2>&1)
run_test "Invalid element name" "could not find" "$RESULT"

# Summary
echo ""
echo "Tests completed: $PASS_COUNT/$TEST_COUNT passed"
