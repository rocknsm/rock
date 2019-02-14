#!/bin/bash

# This script provides dns shortname look for kubernetes external services.
# Point your dns to the master server

# Make sure kubectl exists before even trying this awesomeness
if [ -f /usr/bin/kubectl ]; then
    
    # Get all services with external ips and store in dnsmasq_kube_hosts.tmp
    kubectl get services --all-namespaces --no-headers=true | grep -v '<none>' | awk '{ print $5 " " $2 ".lan" }' > /etc/dnsmasq_kube_hosts.tmp
    
    # check if file dnsmasq_kube_hosts exists if not create it
    if [ ! -f /etc/dnsmasq_kube_hosts ]; then
        touch /etc/dnsmasq_kube_hosts
    fi

    # check if file dnsmasq_kube_hosts.tmp exists if not create it
    if [ ! -f /etc/dnsmasq_kube_hosts.tmp ]; then
        touch /etc/dnsmasq_kube_hosts.tmp
    fi
    
    # Setup couple variables to compare later
    dns_list=$(cat /etc/dnsmasq_kube_hosts.tmp)
    current_list=$(cat /etc/dnsmasq_kube_hosts)

    # Compare the lists if they dont match 
    # move dnsmasq_kube_hosts.tmp to dnsmasq_kube_hosts 
    # and restart dnsmasq
    if [ "$dns_list" != "$current_list" ]; then
        mv /etc/dnsmasq_kube_hosts.tmp /etc/dnsmasq_kube_hosts
        systemctl restart dnsmasq
    fi

fi
