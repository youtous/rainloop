load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'test_helper/common'

function setup() {
  DOCKER_FILE_TESTS="$BATS_TEST_DIRNAME/files/docker-compose.test.yml"
  run_setup_file_if_necessary
}

function teardown() {
  run_teardown_file_if_necessary
}

@test "first" {
    skip 'only used to call setup_file from setup'
}

@test "check: http status 200 after 20s" {
  run repeat_until_success_or_timeout "$TEST_TIMEOUT_IN_SECONDS" sh -c "curl http://$TEST_LOCALHOST_HOSTNAME:8001 -i | grep -F 'HTTP/1.1 200 OK'"
  assert_success

  sleep 20

  run repeat_until_success_or_timeout "$TEST_TIMEOUT_IN_SECONDS" sh -c "curl http://$TEST_LOCALHOST_HOSTNAME:8001 -i | grep -F 'HTTP/1.1 200 OK'"
  assert_success
}

@test "last" {
    skip 'only used to call teardown_file from teardown'
}

setup_file() {
  docker-compose -p "$TEST_STACK_NAME" -f "$DOCKER_FILE_TESTS" down -v --remove-orphans
  docker-compose -p "$TEST_STACK_NAME" -f "$DOCKER_FILE_TESTS" up -d
}

teardown_file() {
  docker-compose -p "$TEST_STACK_NAME" -f "$DOCKER_FILE_TESTS" down -v --remove-orphans
}
