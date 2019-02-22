#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))
ROCK_HOME=/usr/share/rock

cd ${ROCK_HOME}/playbooks

# Check for /srv/rocknsm/repodata/repomd.xml.asc and set GPG checking bool:
if [[ -f /srv/rocknsm/repodata/repomd.xml.asc ]]; then
  echo "Signing data for local repo found. Enabling GPG checking."
  sed -i 's|rock_offline_gpgcheck: .*|rock_offline_gpgcheck: 1|' ${ROCK_HOME}/playbooks/group_vars/all.yml
  sed -i 's|rock_offline_gpgcheck: .*|rock_offline_gpgcheck: 1|' /etc/rocknsm/config.yml
else
  echo "No signing data for local repo found. Disabling GPG checking."
  sed -i 's|rock_offline_gpgcheck: .*|rock_offline_gpgcheck: 0|' ${ROCK_HOME}/playbooks/group_vars/all.yml
  sed -i 's|rock_offline_gpgcheck: .*|rock_offline_gpgcheck: 0|' /etc/rocknsm/config.yml
fi

ansible-playbook "${ROCK_HOME}/playbooks/generate-defaults.yml"
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Dumping default variables failed! Verify you can run sudo without a password." 1>&2
  exit $retVal
fi
echo "Defaults generated. Adjust /etc/rocknsm/config.yml as needed."
