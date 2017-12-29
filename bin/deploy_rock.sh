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
Main() {
    
	# Get the current directory of deploy_rock.sh (Ex: if deploy rock is in /root/rock/bin/deploy_rock.sh,
	# this will return /root/rock/bin
	SCRIPT_PATH=$(dirname $(readlink -f $0))

	# Returns rock's directory. Ex: If deploy_rock.sh is in /root/rock/bin then this returns /root/rock
	TOPLEVEL=$(dirname ${SCRIPT_PATH})

	VERBOSE_FLAGS=
	if [ "x${DEBUG}" != "x" ]; then
		VERBOSE_FLAGS="-vvv"
	fi
	
	# The purpose of the following conditional block is to ensure the user has run generate_defaults before running
	# deploy_rock. If not, it will prompt them to do so.
	
	# The bash option -e checks if a file exists. This line checks to see if config.yml has already been generated.
	if [[ ! -e /etc/rocknsm/config.yml ]]; then
	
        	# This gets the name of the running script. In this case it is deploy_rock.sh
        	SOURCE="${BASH_SOURCE[0]}"
			
			# The -h option checks to see if a file exists and is a symbolic link. 
			# The purpose of this code is to resolve deploy_rock.sh in case it is a symlink. At the end, the DIR
			# variable will contain deploy_rock.sh's current directory. So if deploy_rock.sh is in /root/rock/bin
			# that's what will be returned. If it has been symlinked, it will return the actual file path.
        	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
			
        		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        		SOURCE="$(readlink "$SOURCE")"
				
        		# If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located.
        		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
				
        	done
			
			# Contains deploy_rock.sh's directory
        	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
		Generate_config
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
Stand_alone() {
ansible-playbook "${TOPLEVEL}/playbooks/all-in-one.yml" ${VERBOSE_FLAGS}
}
#=======================
Server() {
ansible-playbook "${TOPLEVEL}/playbooks/server.yml" ${VERBOSE_FLAGS}
}
#=======================
Sensor() {
ansible-playbook "${TOPLEVEL}/playbooks/sensor.yml" ${VERBOSE_FLAGS}
}
#=======================
# Generate the /etc/rocknsm/config.yml 
Generate_config() {

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
echo "+        [ 1 ] Install a Stand alone system (everything on this box)   +"
echo "+                                                                      +"
echo "+        [ 2 ] Server Install: only the services for a Server          +"
echo "+                                                                      +"
echo "+        [ 3 ] Sensor Install: only the services for a Sensor          +"
echo "+                                                                      +"
echo "+                                                                      +"
echo "+                                                                      +"
echo "+        [ X ] Exit Script                                             +"
echo "+                                                                      +"
echo "+                                                                      +"
Footer
read -p "Please make a Selection: " mainmenu_option
case $mainmenu_option in
	1) clear && Stand_alone;;
	2) clear && Server;; 
	3) clear && Sensor;;
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
}
#
#Script Execution:
########################
Main
check_for_config_file
