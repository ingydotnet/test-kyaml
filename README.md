test-kyaml
==========

A test suite for validating kyaml functionality in Kubernetes. This project
provides a containerized environment for testing YAML to KYAML conversions using
YAMLScript-based tests.


## Overview

This test suite is designed to validate the kyaml implementation in Kubernetes,
focusing on YAML to KYAML conversion accuracy and edge cases. It uses a Docker
container to provide a consistent testing environment and YAMLScript for writing
expressive tests.


## Prerequisites

- Docker
- Make
- Git

## Usage

To run all tests:

```bash
$ git clone https://github.com/ingydotnet/test-kyaml
$ cd test-kyaml
$ make test
docker exec -it kyaml-test-server make test test=./test/*.ys
prove -v ./test/*.ys
./test/basic.ys ..
ok 1 - Basic Mapping
ok 2 - Basic Sequence
ok 3 - Unquoted Keys
1..3
ok
All tests successful.
Files=1, Tests=3,  0 wallclock secs ( 0.01 usr  0.00 sys +  0.02 cusr  0.03 csys =  0.06 CPU)
Result: PASS
```

This will:
1. Build the Docker container if needed
2. Clone the Kubernetes repository (thockin/kubernetes kyaml branch)
3. Build the `yaml_renderer`
4. Run all tests in the test/ directory

The first `make test` will take a couple minutes to set things up.
After that tests will run quickly.


### Writing Tests

Tests are written in YAMLScript (`.ys` files) in the `test/` directory. Each
test case specifies:
- Input YAML
- Expected KYAML output
- Test name and metadata

Example test case:

```yaml
- name: Basic Mapping
  yaml: |
    k1: one
    k2: 2
  kyaml: |
    ---
    {
      k1: "one",
      k2: 2,
    }
```


### Make Commands

- `make shell` - Open a shell in the test container
- `make status` - Check container status
- `make stop` - Stop the container
- `make build` - Rebuild the container
- `make remove` - Remove the container image
