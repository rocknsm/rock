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
	SCRIPT_PATH=$(dirname $(readlink -f $0))
	TOPLEVEL=$(dirname ${SCRIPT_PATH})
	VERBOSE_FLAGS=
	if [ "x${DEBUG}" != "x" ]; then
		VERBOSE_FLAGS="-vvv"
	fi
	if [[ ! -e /etc/rocknsm/config.yml ]];then
        	#Find script working dir
        	SOURCE="${BASH_SOURCE[0]}"
        	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        		SOURCE="$(readlink "$SOURCE")"
        		# If $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located.
        		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
        	done
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

	cd ${TOPLEVEL}
	ansible-playbook "${TOPLEVEL}/playbooks/deploy-rock.yml" ${VERBOSE_FLAGS}

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
