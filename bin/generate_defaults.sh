#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))
TOPLEVEL=$(dirname ${SCRIPT_PATH})

ansible-playbook "${TOPLEVEL}/playbooks/generate-defaults.yml" 2>&1 1>/dev/null
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Dumping default variables failed! Verify you can run sudo without a password." 1>&2
  exit $retVal
fi
echo "Defaults generated. Adjust /etc/rocknsm/config.yml as needed."
