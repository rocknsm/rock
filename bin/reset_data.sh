#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))
ROCK_HOME=/usr/share/rock
VERBOSE_FLAGS=
if [ "x${DEBUG}" != "x" ]; then
  VERBOSE_FLAGS="-vvv"
fi


read -p "Do you really want to delete all rock data? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "Stopping Rock Services"


cd ${ROCK_HOME}/playbooks
ansible-playbook "${ROCK_HOME}/playbooks/delete-data.yml" ${VERBOSE_FLAGS}
ansible-playbook "${ROCK_HOME}/playbooks/deploy-rock.yml" ${VERBOSE_FLAGS}

/usr/local/bin/rockctl start
fi
