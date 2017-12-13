#!/bin/bash
SCRIPT_PATH=$(dirname $(readlink -f $0))
TOPLEVEL=$(dirname ${SCRIPT_PATH})
VERBOSE_FLAGS=
if [ "x${DEBUG}" != "x" ]; then
  VERBOSE_FLAGS="-vvv"
fi
if [[ ! -e /etc/rocknsm/config.yml ]];then
        echo "[-] You must run generate_defaults.sh prior to deploying for the first time. "
        read -p "Would you like to generate the defaults now?  [y/n] " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]];then
                echo ''
                /bin/bash generate_defaults.sh
                echo "Please verify configuration settings in /etc/rocknsm/config.yml before re-running the deploy script."
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
