#!/usr/bin/bash

# broctl should ALWAYS run as the bro user!
sudo -u bro /usr/bin/broctl "$@"
