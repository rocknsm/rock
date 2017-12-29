#!/usr/bin/bash

# broctl should ALWAYS run as the bro user!
sudo -u bro /opt/bro/bin/broctl $@

