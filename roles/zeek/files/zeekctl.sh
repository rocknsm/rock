#!/usr/bin/bash

# zeekctl should ALWAYS run as the zeek user!
sudo -u zeek /usr/bin/zeekctl "$@"
