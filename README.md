## Response Operation Collections Kit Reference Build
----

This build was created and tested using CentOS 7. I pretty much guarantee that it won't work with anything else other than RHEL 7.

**BE ADVISED:**  This build process takes 3-10 minutes depending on your underlying hardware.  There will be times where it seems like it quit.  Be patient.  You'll know when it's done, for better or worse.

### Vagrant
**NOTE:**   
This Vagrantfile is configured to give the VM 8GB of RAM.  If your system can't do that you should buy a new system or adjust the `vm.memory` value.  Anything below 4 is going to run like poopoo.
``` 
git clone https://github.com/CyberAnalyticDevTeam/SimpleRock.git
cd simplerock
vagrant up
```

### Physical/Virtual/Non-Vagrant
**NOTE:**   
The system you run this on should have at least 2 network interfaces and more than 4GB of RAM, with EL7 already installed.
```
curl -O -k https://bintray.com/artifact/download/cyberdev/capes/chef-12.3.0-1.el6.x86_64.rpm
rpm -Uvh chef-12.3.0-1.el6.x86_64.rpm
yum install git -y
git clone https://github.com/CyberAnalyticDevTeam/SimpleRock.git
cd simplerock
chef-client -z -r "recipe[simplerock]"
```

## Usage
----
#### Start / Stop / Status
Accomplished with `rock_stop`, `rock_start`, and `rock_status`.


`rock_stop`
```
[root@simplerockbuild ~]# rock_stop
Stopping Bro...
stopping worker-1-1 ...
stopping worker-1-2 ...
stopping proxy-1 ...
stopping manager ...
Stopping Logstash...
Stopping Kibana...
Stopping Elasticsearch...
Stopping Kafka...
Stopping Zookeeper...
```

`rock_start`
```
[root@simplerockbuild ~]# rock_start
Starting Zookeeper...
   Active: active (running) since Wed 2015-12-02 17:12:02 UTC; 5s ago
Starting Elasticsearch...
   Active: active (running) since Wed 2015-12-02 17:12:07 UTC; 5s ago
Starting Kafka...
   Active: active (running) since Wed 2015-12-02 17:12:12 UTC; 5s ago
Starting Logstash...
   Active: active (running) since Wed 2015-12-02 17:12:17 UTC; 5s ago
Starting Kibana...
   Active: active (running) since Wed 2015-12-02 17:12:22 UTC; 5s ago
Starting Bro...
removing old policies in /data/bro/spool/installed-scripts-do-not-touch/site ...
removing old policies in /data/bro/spool/installed-scripts-do-not-touch/auto ...
creating policy directories ...
installing site policies ...
generating cluster-layout.bro ...
generating local-networks.bro ...
generating broctl-config.bro ...
generating broctl-config.sh ...
updating nodes ...
manager scripts are ok.
proxy-1 scripts are ok.
worker-1-1 scripts are ok.
worker-1-2 scripts are ok.
starting manager ...
starting proxy-1 ...
starting worker-1-1 ...
starting worker-1-2 ...
Getting process status ...
Getting peer status ...
Name         Type    Host             Status    Pid    Peers  Started
manager      manager localhost        running   20389  ???    02 Dec 17:12:34
proxy-1      proxy   localhost        running   20438  ???    02 Dec 17:12:35
worker-1-1   worker  localhost        running   20484  ???    02 Dec 17:12:36
worker-1-2   worker  localhost        running   20485  ???    02 Dec 17:12:36
```

`rock_status`
```
[root@simplerockbuild ~]# rock_status
Zookeeper...
   Active: active (running) since Wed 2015-12-02 17:12:02 UTC; 2min 7s ago
Elasticsearch...
   Active: active (running) since Wed 2015-12-02 17:12:07 UTC; 2min 2s ago
Kafka...
   Active: active (running) since Wed 2015-12-02 17:12:12 UTC; 1min 57s ago
Logstash...
   Active: active (running) since Wed 2015-12-02 17:12:17 UTC; 1min 52s ago
Kibana...
   Active: active (running) since Wed 2015-12-02 17:12:22 UTC; 1min 47s ago
Bro...
Getting process status ...
Getting peer status ...
Name         Type    Host             Status    Pid    Peers  Started
manager      manager localhost        running   20389  ???    02 Dec 17:12:34
proxy-1      proxy   localhost        running   20438  ???    02 Dec 17:12:35
worker-1-1   worker  localhost        running   20484  ???    02 Dec 17:12:36
worker-1-2   worker  localhost        running   20485  ???    02 Dec 17:12:36
```

## Basic Troubleshooting
----
#### Functions Check:
```
# After the initial build, the ES cluster will be yellow because the marvel index will think it's missing a replica.  Run this to fix this issue.  This job will run from cron just after midnight every day.
/usr/local/bin/es_cleanup.sh

# Check to see that the ES cluster says it's green:
curl -s localhost:9200/_cluster/health | jq '.'

# See how many documents are in the indexes.  The count should be non-zero.
curl -s localhost:9200/_all/_count | jq '.'

# You can fire some traffic across the sensor at this point to see if it's collecting.
tcpreplay -i [your monitor interface] /path/to/a/test.pcap

# After replaying some traffic, or just waiting a bit, the count should be going up.
curl -s localhost:9200/_all/_count | jq '.'

# You should have plain text bro logs showing up in /data/bro/logs/current/:
ls -ltr /data/bro/logs/current/

# Kafkacat is your kafka swiss army knife.  This command will consume the current queue.  You should see a non-zero offset.
kafkacat -C -b localhost -t bro_raw -e | wc -l

# If you haven't loaded kibana already, it should be running on port 5601.  This just verifies while you're still on the command line.
netstat -planet | grep node
```

## Key web interfaces:
----

IPADDRESS = The management interface of the box, or "localhost" if you did the vagrant build.

http://IPADDRESS:5601 - Kibana

http://IPADDRESS:9200/_plugin/marvel - Marvel (To watch the health of elasticsearch.)

http://IPADDRESS:9200/_plugin/sql - Query your ES data with SQL.


## THANKS
----
This architecture is made possible by the efforts of the Missouri National Guard Cyber Team, and especially Critical Stack and BroEZ for donating talent and resources to further development.


## Approach
----
The Chef recipe that drives this build strives not to use external recipes and cookbooks where possible.  The reasoning behind this is to make the simplerock recipe a "one-stop" reference for a manual build.  This allows users to use the build process as a guide when doing larger scale production roll outs without having to decypher a labrynth of dependencies.

Templated config files have comment sections added near key config items with useful info.  They don't all have it, but they get added as remembered.


