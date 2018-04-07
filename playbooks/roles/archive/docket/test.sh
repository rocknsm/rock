#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#
# License: MIT

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
playbook=${playbook:-"test.yml"}
test_idempotence=${test_idempotence:-"true"}

export ANSIBLE_ROLES_PATH=$(pwd)/../

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/tests/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  TERM=xterm ansible-galaxy install -r tests/requirements.yml
fi

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
TERM=xterm ansible-playbook tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: TERM=xterm ansible-playbook tests/$playbook"${neutral}
TERM=xterm ANSIBLE_FORCE_COLOR=1 ansible-playbook --become --inventory tests/inventory tests/$playbook

if [ "$test_idempotence" = true ]; then
  # Run Ansible playbook again (idempotence test).
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  ansible-playbook --become --inventory tests/inventory tests/$playbook | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi
