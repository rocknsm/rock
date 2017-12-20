#!/bin/sh
#
#Info
#====
#	file: generate_defaults.sh
# 	name: Generate defaults Script
#
#
# Description
# =================
# Initializes the generate-defaults.yml playbook creating base file structure in /etc and listing available interfaces.
#
# Notes
# =====
#
#
# Functions
# =====
#
# Main function to call the generate playbook
main() {
	SCRIPT_PATH=$(dirname $(readlink -f $0))
	TOPLEVEL=$(dirname ${SCRIPT_PATH})

	cd ${TOPLEVEL}
	ansible-playbook "${TOPLEVEL}/playbooks/generate-defaults.yml" 2>&1 1>/dev/null
	retVal=$?
	if [ $retVal -ne 0 ]; then
  		echo "Dumping default variables failed! Verify you can run sudo without a password." 1>&2
  	exit $retVal
	fi
	echo "Defaults generated. Adjust /etc/rocknsm/config.yml as needed."
}
#
# Interface function to input interfaces into /etc/rocknsm/config.yml
add_interfaces() {
        #Define useable network interfaces 
        INTERFACES=($(ip link show | grep '<BROADCAST,MULTICAST' | grep --invert-match 'nic' | awk '{print $2}' | tr --delete :))
        #Write new interfaces into the /etc/rocknsm/config.yml
        COUNTER=0
        for i in "${INTERFACES[@]}"; do
                #Check for interfaces without a current IP address: If so delete Ansible auto generated interfaces.
                if ! ip -f inet addr show ${i} | grep --quiet inet; then
                        if [ $COUNTER = 0 ];then
                                delete_ansible_interfaces
                                (( COUNTER++ ))
                        fi
                        #Write interface into /etc/rocknsm/config.yml
                        sed -i "/rock_monifs:/a \ \ \ \ -\ ${i}" /etc/rocknsm/config.yml
                fi
        done
}

#
# Delete Ansible generated interfaces from /etc/rocknsm/config.yml
delete_ansible_interfaces() {
        while (grep -A 1 rock_monifs: /etc/rocknsm/config.yml | grep - > /dev/null); do
                sed -i '/rock_monifs:/ {n;d}' /etc/rocknsm/config.yml
        done

}
#
#Script Running
main
add_interfaces
