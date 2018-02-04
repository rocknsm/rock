#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))
TOPLEVEL=$(dirname ${SCRIPT_PATH})
VERBOSE_FLAGS=
if [ "x${DEBUG}" != "x" ]; then
  VERBOSE_FLAGS="-vvv"
fi


read -p "Do you really want to delete all rock data? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

cd ${TOPLEVEL}/playbooks
ansible-playbook "${TOPLEVEL}/playbooks/delete-data.yml" ${VERBOSE_FLAGS}
ansible-playbook "${TOPLEVEL}/playbooks/deploy-rock.yml" ${VERBOSE_FLAGS}

/sbin/rock_start
fi