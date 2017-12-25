#!/bin/sh
#
#Info
#====
#	file: deploy_rock.sh
# 	name: Deploy Rock Script
#
#
# Description
# =================
# Deploys ROCKNSM using the deploy_rock.yml playbook.
#
# Notes
# =====
#
#
# Functions
# =====
#
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
	fi

	cd "${TOPLEVEL}/playbooks"
	ansible-playbook "${TOPLEVEL}/playbooks/all-in-one.yml" ${VERBOSE_FLAGS}

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
#
#Script Running
main
