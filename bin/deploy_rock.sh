#!/bin/sh
#
#Info
#########################
#	file: deploy_rock.sh
# 	name: Deploy Rock Script
#
#
# Description
#########################
# Deploys ROCKNSM using the playbook associated based of option of playbooks.
#
#
# Notes
########################
#
#
# Functions
#########################
# Main function to call the deploy_rock.yml playbook
main() {

	# Get the current directory of deploy_rock.sh (Ex: if deploy rock is in /root/rock/bin/deploy_rock.sh,
	# this will return /root/rock/bin
	SCRIPT_PATH=$(dirname $(readlink -f $0))

	# Returns rock's directory. Ex: If deploy_rock.sh is in /root/rock/bin then this returns /root/rock
	TOPLEVEL=$(dirname ${SCRIPT_PATH})

	VERBOSE_FLAGS=
	if [ "x${DEBUG}" != "x" ]; then
		VERBOSE_FLAGS="-vvv"
	fi

	cd "${TOPLEVEL}/playbooks"
	Mainmenu

	if [ $? -eq 0 ]; then
		cat << 'EOF'
	┌──────────────────────────────────────────────────────────────────────────────┐
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                       Thank you for installing:                              │
	│                                                                              │
	│                                                                              │
	│                 :::::::..       ...       .,-:::::  :::  .                   │
	│                 ;;;;``;;;;   .;;;;;;;.  ,;;;'````'  ;;; .;;,.                │
	│                  [[[,/[[['  ,[[     [[,[[[          [[[[[/'                  │
	│                  $$$$$$c    $$$,     $$$$$$        _$$$$,                    │
	│                  888b "88bo,"888,_ _,88P`88bo,__,o,"888"88o,                 │
	│                  MMMM   "W"   "YMMMMMP"   "YUMMMMMP"MMM "MMP"                │
	│                          :::.    :::. .::::::. .        :                    │
	│                          `;;;;,  `;;;;;;`    ` ;;,.    ;;;                   │
	│                            [[[[[. '[['[==/[[[[,[[[[, ,[[[[,                  │
	│                            $$$ "Y$c$$  '''    $$$$$$$$$"$$$                  │
	│                            888    Y88 88b    dP888 Y88" 888o                 │
	│                            MMM     YM  "YMmMY" MMM  M'  "MMM                 │
	│                                                                              │
	|                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	│                                                                              │
	└──────────────────────────────────────────────────────────────────────────────┘
EOF
	fi
}
#=======================
stand_alone() {
ansible-playbook "${TOPLEVEL}/playbooks/site.yml" --extra-vars "standalone=True" ${VERBOSE_FLAGS}
}
#=======================
server() {
ansible-playbook "${TOPLEVEL}/playbooks/site.yml" --extra-vars "serverlocal=True" ${VERBOSE_FLAGS}
}
#=======================
sensor() {
ansible-playbook "${TOPLEVEL}/playbooks/site.yml" --extra-vars "sensorlocal=True" ${VERBOSE_FLAGS}
}
#=======================
deploy() {
ansible-playbook "${TOPLEVEL}/playbooks/site.yml" ${VERBOSE_FLAGS}
}
#=======================
# Generate the /etc/rocknsm/config.yml
generate_config() {
echo "[-] You must run generate_defaults.sh prior to deploying for the first time. "
read -p "Would you like to generate the defaults now?  [y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
	echo ''
        /bin/bash $DIR/generate_defaults.sh
	echo "**** Please verify configuration settings in /etc/rocknsm/config.yml before re-running the deploy script."
	sleep 3
	exit
else
	echo ''
	exit
fi
}
#=======================
# Main menu to call all available install options be it a stand alone system or just a sensor.
Mainmenu() {
clear
Header
echo "+     [ 1 ] Install a Stand alone system (everything on this box)      +"
echo "+                                                                      +"
echo "+     [ 2 ] Local Server Install: only the services for a server       +"
echo "+                                                                      +"
echo "+     [ 3 ] Local Sensor Install: only the services for a sensor       +"
echo "+                                                                      +"
echo "+     [ 4 ] Multinode Remote Install                                   +"
echo "+                                                                      +"
echo "+                                                                      +"
echo "+     [ X ] Exit Script                                                +"
echo "+                                                                      +"
echo "+                                                                      +"
Footer
read -p "Please make a Selection: " mainmenu_option
case $mainmenu_option in
	1) clear && stand_alone;;
	2) clear && server;;
	3) clear && sensor;;
	4) clear && deploy;;
	x|X) clear && exit ;;
	*) echo "Invalid input" && sleep 1 && Mainmenu;;
esac
}
#=======================
Header() {
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                                                                      +"
echo "+                   Deployment Configuration Options                   +"
echo "+                                                                      +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                                                                      +"
}
#=======================
Footer() {
echo "+                                                                      +"
echo "+                                                                      +"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
}
#
#Script Execution:
########################
main
