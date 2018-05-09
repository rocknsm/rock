SHELL=/bin/bash

# Confirm Ansible is installed.
CHECK := $(shell command -v ansible-playbook 2> /dev/null)
INVENTORY ?= 'inventory/dev/inventory.yml'
PLAYBOOK ?= 'site.yml'

.PHONY: all dev genkeys rerun common common-nokeys kubernetes ceph elasticsearch logstash kibana metricbeat kafka bro moloch suricata stenographer docket kubernetes-rerun ceph-rerun elasticsearch-rerun logstash-rerun kibana-rerun metricbeat-rerun kafka-rerun bro-rerun moloch-rerun suricata-rerun

# Default target, build *and* run tests
all:
ifndef CHECK
	$(error Ansible is not installed. Install Ansible with 'yum update -y && yum install -y ansible')
endif
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --ask-pass

preflight:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t preflight

dev:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --ask-pass

rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY)

common:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --ask-pass -t genkeys,common

common-nokeys:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t common

dnsmasq:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t dnsmasq

genkeys:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --ask-pass -t genkeys

kubernetes:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kube-master,kube-node -e reinstall=true

ceph:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t ceph

elasticsearch:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t elasticsearch

logstash:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t logstash

kibana:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kibana

metricbeat:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t metricbeat

kafka:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kafka

bro:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t bro

moloch:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t moloch

suricata:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t suricata

stenographer:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t stenographer

docket:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t docket

dnsmasq-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t dnsmasq,kube-master,kube-node,ceph,elasticsearch,logstash,kibana,metricbeat,kafka,bro,moloch,suricata -e reinstall=true

kubernetes-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kube-master,kube-node,ceph,elasticsearch,logstash,kibana,metricbeat,kafka,bro,moloch,suricata -e reinstall=true

ceph-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t ceph,elasticsearch,logstash,kibana,metricbeat,kafka,bro,moloch,suricata

elasticsearch-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t elasticsearch,logstash,kibana,metricbeat,kafka,bro,moloch,suricata

logstash-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t logstash,kibana,metricbeat,kafka,bro,moloch,suricata

kibana-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kibana,metricbeat,kafka,bro,moloch,suricata

metricbeat-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t metricbeat,kafka,bro,moloch,suricata

kafka-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t kafka,bro,moloch,suricata

bro-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t bro,moloch,suricata

moloch-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t moloch,suricata

suricata-rerun:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) -t suricata
