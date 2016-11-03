#!/bin/bash 
ansible-playbook -i inventory/all-in-one.ini -c local -b simplerock.yml 
