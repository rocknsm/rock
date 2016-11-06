#!/bin/bash 
DEBUG=1 ansible-playbook --inventory inventory/all-in-one.ini --connection local --become --force-handlers simplerock.yml 
