#!/bin/bash 
ansible-playbook -i inventory/all-in-one.ini -c local -b render_default_vars.yml 2>&1 1>/dev/null
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Dumping default variables failed! Verify you can run sudo without a password." 1>&2
  exit $retVal
fi
