Filebeat
=========

Used to read in Suricata and FSF data.

Paths in Filebeat
-----------------

Log paths can be exact paths or can be wildcards:
```
filebeat.prospectors:
- type: log
  paths:
    - /var/log/*.log
  fields:
    type: syslog
output.logstash:
  hosts: ["localhost:5044"]
```
