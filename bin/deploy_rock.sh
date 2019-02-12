#!/bin/bash
SCRIPT_PATH=$(dirname $(readlink -f $0))
ROCK_HOME=/usr/share/rock
VERBOSE_FLAGS=
if [ "x${DEBUG}" != "x" ]; then
  VERBOSE_FLAGS="-vvv"
fi

cd ${ROCK_HOME}/playbooks
ansible-playbook "${ROCK_HOME}/playbooks/site.yml" ${VERBOSE_FLAGS}

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
