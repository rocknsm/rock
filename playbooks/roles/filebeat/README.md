Filebeat
=========

Central database for managing all Rock data.

Requirements
------------

Currently none.

Role Variables
--------------

TODO

Dependencies
------------

Paths in Filebeat
-----------------

Log paths can be exact paths or can be wildcards:
filebeat.prospectors:
- type: log
  paths:
    - /var/log/*.log
  fields:
    type: syslog
output.logstash:
  hosts: ["localhost:5044"]
