## Response Operation Collections Kit Reference Build

[![Join the chat at https://gitter.im/rocknsm/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/rocknsm/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) 

See the [ROCK 2.0 User Guide](https://rocknsm.gitbooks.io/rocknsm-guide/content/).


This build was created and tested using CentOS 7.3. I pretty much guarantee that it won't work with anything else other than RHEL 7.  Unless you have an operational need, I would suggest basing your system off of CentOS 7.3 (build 1611), as that is where the bulk of the testing of this has happened.

**BE ADVISED:**  This build process takes 3-10 minutes depending on your underlying hardware.  There will be times where it seems like it quit.  Be patient.  You'll know when it's done, for better or worse.

### Differences in ROCK 2.0

See [Getting Started with ROCK 2.0](docs/guide/getting-started.adoc).

### Vagrant
**NOTE:**
This Vagrantfile is configured to give the VM 8GB of RAM.  If your system can't do that you should buy a new system or adjust the `vm.memory` value.  Anything below 8 is going to run like poopoo. You will also need to have a host-only adapter configured named `vboxnet0`.
``` 
git clone https://github.com/rocknsm/rock.git
cd rock
vagrant up
```

### Physical/Virtual/Non-Vagrant
**NOTE:**   
The system you run this on should have at least 2 network interfaces and more than 8GB of RAM, with an OS (RHEL or CentOS 7) already installed.
```
sudo yum update -y && reboot
sudo yum install -y epel-release
sudo yum install -y git ansible
git clone https://github.com/rocknsm/rock.git
cd rock/bin
sudo ./deploy_rock.sh
```

## Minimum Hardware Recommendations 
#### (For anything other than a Vagrant build)

**NOTE:** This is a shadow of a recommendation of a guideline.  Your mileage may vary.  No returns or refunds.

*  CPU
  *  4 or more physical cores.  
*  Memory
  *  16GB (You can get away with 8GB, but it won't collect for long.)
*  Storage
  *  256GB, with 200+ of that dedicated to `/data`. Honestly, throw everything you can at it.  The higher the IOPS the better.
*  Network
  *  The system needs at least 2 network interfaces, one for management and one for collection.

**GOLDEN RULE:** If you throw hardware at it, ROCK will use it.  It will require some tuning to do so, but we'll be documenting that soon enough.

## Usage

#### Start / Stop / Status
Accomplished with `rock_stop`, `rock_start`, and `rock_status`.

**NOTE:** These may need to be prefaced with /usr/local/bin/ depending on your PATH.

`sudo rock_stop`
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

`sudo rock_start`
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

`sudo rock_status`
```
[root@simplerockbuild ~]# /usr/local/bin/rock_status
 ✓ Check each monitor interface is live
 ✓ Check for interface errors
 ✓ Check monitor interface for tx packets
 ✓ Check PF_RING settings
 ✓ Check that broctl is running
 ✓ Check for bro-detected packet loss
 ✓ Check that zookeeper is running
 ✓ Check that zookeeper is listening
 ✓ Check that client can connect to zookeeper
 ✓ Check that kafka is running
 ✓ Check that kafka is connected to zookeeper
 ✓ Check that logstash is running
 ✓ Check that elasticsearch is running
 ✓ Check that kibana is running

14 tests, 0 failures
```

## Basic Troubleshooting
    
#### Functions Check:
```
# After the initial build, the ES cluster will be yellow because the marvel index will think it's missing a replica.  Run this to fix this issue.  This job will run from cron just after midnight every day.
/usr/local/bin/es_cleanup.sh 2>&1 > /dev/null

# Check to see that the ES cluster says it's green:
curl -s localhost:9200/_cluster/health | jq '.'

# See how many documents are in the indexes.  The count should be non-zero.
curl -s localhost:9200/_all/_count | jq '.'

# You can fire some traffic across the sensor at this point to see if it's collecting.
# NOTE: This requires that you upload your own test PCAP to the box.
sudo tcpreplay -i [your monitor interface] /path/to/a/test.pcap

# After replaying some traffic, or just waiting a bit, the count should be going up.
curl -s localhost:9200/_all/_count | jq '.'

# You should have plain text bro logs showing up in /data/bro/logs/current/:
ls -ltr /data/bro/logs/current/

# Kafkacat is your kafka swiss army knife.  This command will consume the current queue.  You should see a non-zero offset.
kafkacat -C -b localhost -t bro_raw -e | wc -l

# If you haven't loaded kibana already, it should be running on port 5601.  This just verifies while you're still on the command line.
sudo netstat -planet | grep node
```

## Key web interfaces:
    
IPADDRESS = The management interface of the box, or "localhost" if you did the vagrant build.

http://IPADDRESS - Kibana


## Full Packet Capture
   
Google's Stenographer is installed and configured in this build.  However, it is disabled by default.  There are a few reasons for this: First, it can be too much for Vagrant builds on meager hardware.  Second, you really need to make sure you've mounted /data over sufficient storage before you start saving full packets.  Once you're ready to get nuts, enable and start the service with `systemctl enable stenographer.service` and then `systemctl start stenographer.service`.  Stenographer is already stubbed into the `/usr/local/bin/rock_{start,stop,status}` scripts, you just need to uncomment it if you're going to use it. 

## THANKS
   
This architecture is made possible by the efforts of the Missouri National Guard Cyber Team for donating talent and resources to further development.


## Approach

The Ansible playbook that drives this build strives not to use any external roles or other dependencies. The reasoning behind this is to make the rock playbook a "one-stop" reference for a manual build. This allows users to use the build process as a guide when doing larger scale production roll outs without having to decipher a labyrinth of dependencies.

Templated config files have comment sections added near key config items with useful info.  They don't all have it, but they get added as remembered.


