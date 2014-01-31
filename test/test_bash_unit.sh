#!/bin/bash

test_fail_fails() {
  (fail >/dev/null) && \
  (
    echo "FAILURE: fail must fail !!!"
    exit 1
  ) || \
  echo "OK" > /dev/null
}

#fail can now be used in the following tests

test_assert_fail_succeeds() {
  (assert_fail false) || fail 'assert_fail should succeed' 
}

test_assert_fail_fails() {
  (assert_fail true >/dev/null) && fail 'assert_fail should fail' || true
}

#assert_fail can now be used in the following tests

test_assert_succeeds() {
  assert true || fail 'assert should succeed'
}

test_assert_fails() {
  assert_fail "assert false" "assert should fail"
}

#assert can now be used in the following tests

test_assert_equals_fails_when_not_equal() {
  assert_fail \
    "assert_equals toto tutu" \
    "assert_equals should fail"
}

test_assert_equals_succeed_when_equal() {
  assert \
    "assert_equals 'toto tata' 'toto tata'"\
    'assert_equals should succeed'
}

#assert_equals can now be used in the following tests

test_fail_prints_failure_message() {
  assert_equals 'failure message' \
    "$(fail 'failure message' | tail -n +2 | head -1)" \
    "unexpected error message"
}

test_fail_prints_where_is_error() {
  assert_equals "${BASH_SOURCE}:${FUNCNAME}():${LINENO}" \
	"$(fail | tail -n +3 | head -1)"
}

test_assert_status_code_succeeds() {
  assert "assert_status_code 3 'exit 3'" \
    "assert_status_code should succeed"
}

test_assert_status_code_fails() {
  assert_fail "assert_status_code 3 true" \
    "assert_status_code should fail"
}

test_assert_show_stderr_when_failure() {
  message="$(assert 'echo some error message >&2; exit 2' | head -1)"
  assert_equals \
    "some error message" \
    "$message"
}
