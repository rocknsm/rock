#!/bin/sh
#
#Info:
########################
#	file: generate_defaults.sh
# 	name: Generate defaults Script
#
#
# Description:
########################
# Initializes the generate-defaults.yml playbook creating base file structure in /etc and listing available interfaces.
#
# Notes:
########################
#
#
# Functions:
########################
# Main function to call the generate playbook
main() {

	# Get the current directory of generate_defaults.sh (Ex: if deploy rock is in /root/rock/bin/generate_defaults.sh,
	# this will return /root/rock/bin
	SCRIPT_PATH=$(dirname $(readlink -f $0))

	# Returns rock's directory. Ex: If generate_defaults.sh is in /root/rock/bin then this returns /root/rock
	TOPLEVEL=$(dirname ${SCRIPT_PATH})

	cd "${TOPLEVEL}/playbooks"

	ansible-playbook "${TOPLEVEL}/playbooks/generate-defaults.yml" 2>&1 1>/dev/null

	# $? returns the return value of the last executed command. In this case, it will be the return value from
	# ansible-playbook
	retVal=$?

	# The return value of ansible-playbook will be non-zero if it failed for some reason.
	if [ $retVal -ne 0 ]; then

      echo "Dumping default variables failed! Verify you can run sudo without a password." 1>&2
  	  exit $retVal

	fi

	echo "Defaults generated. Adjust /etc/rocknsm/config.yml as needed."
}

#Check if /etc/rocknsm/config.yml already exists.
#If it does, warn the user that this script will overwrite that file, and ask if they want to continue.
check_for_config_file(){
	#Check if the file exists
	if [ -f "/etc/rocknsm/config.yml" ]; then
		echo "WARNING: The file '/etc/rocknsm/config.yml' already exists."
		echo "Running this script will overwrite its contents."
		echo "Are you sure you want to continue? Yes or No?"
		read -p "[y/n]: " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			return

		else
			echo "Exiting..."
			exit 0
		#Alternatively we can loop if the user does not actually answer Y|y|N|n.
		#E.g. Please answer 'y' to continue or 'n' to quit.
		#$_
	  fi
	fi
}

check_for_config_file
main
