## Response Operation Collections Kit Reference Build

If you have questions after trying the code and the documentation, please see
our community message boards at http://community.rocknsm.io. This is for discussion
of troubleshooting or general information outside of bugs that you might find.

You can file bugs on the [Issue Tracker](http://github.com/rocknsm/rock/issues/).

See the [ROCK User Guide](https://rocknsm.gitbooks.io/rocknsm-guide/content/) for detailed documentation.

## Minimum Hardware Recommendations
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
Accomplished with `rockctl stop`, `rockctl start`, and `rockctl status`.

**NOTE:** These may need to be prefaced with /usr/local/bin/ depending on your PATH.


## Basic Troubleshooting

#### Functions Check:
```
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

IPADDRESS = The management interface of the box.

https://IPADDRESS - Kibana
https://IPADDRESS:8443 - Docket


## Full Packet Capture

Google's Stenographer is installed and configured in this build.  However, it is disabled by default.  There are a few reasons for this: First, it can be too much for Vagrant builds on meager hardware.  Second, you really need to make sure you've mounted /data over sufficient storage before you start saving full packets.  Once you're ready to get nuts, enable and start the service with `systemctl enable stenographer.service` and then `systemctl start stenographer.service`.  


## THANKS

This architecture is made possible by the efforts of the Missouri National Guard Cyber Team for donating talent and resources to further development.


## Approach

The Ansible playbook that drives this build strives not to use any external roles or other dependencies. The reasoning behind this is to make the rock playbook a "one-stop" reference for a manual build. This allows users to use the build process as a guide when doing larger scale production roll outs without having to decipher a labyrinth of dependencies.

Templated config files have comment sections added near key config items with useful info.  They don't all have it, but they get added as remembered.
