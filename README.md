<p align="center">
<img src="images/rock_full.png">
</p>
</br>

<p align="center">
  <strong>Full Documentation: <a href="https://rocknsm.gitbooks.io/rocknsm-guide/content/">link</a></strong>
</p>

ROCK is a collections platform, in the spirit of Network Security Monitoring by contributors from all over industry and the public sector. It's primary focus is to provide a robust, scalable sensor platform for both enduring security monitoring and incident response missions. The platform consists of 3 core capabilities:

* Passive data acquisition via AF_PACKET, feeding systems for metadata (Bro), signature detection (Suricata), and full packet capture (Stenographer).
* A messaging layer (Kafka and Logstash) that provides flexibility in scaling the platform to meet operational needs, as well as providing some degree of data reliability in transit.
* Reliable data storage and indexing (Elasticsearch) to support rapid retrieval and analysis (Kibana) of the data.

## Features

* Full Packet Capture via Google Stenographer and Docket.
* Protocol Analysis and Metadata via Bro.
* Signature Based Alerting via Suricata.
* Recursive File Scanning via FSF.
* Message Queuing and Distribution via Apache Kafka.
* Message Transport via Logstash.
* Data Storage, Indexing, and Search via Elasticsearch.
* Data UI and Visualization via Kibana.
* Security - The system is developed and tested to run with SELinux enabled.

## Approach

The Ansible playbook that drives this build strives not to use any external roles or other dependencies. The reasoning behind this is to make the rock playbook a "one-stop" reference for a manual build. This allows users to use the build process as a guide when doing larger scale production roll outs without having to decipher a labyrinth of dependencies.

Templated config files have comment sections added near key config items with useful info. They don't all have it, but they get added as remembered.

## Usage

### Operating System Deployment

This system is distributed as an ISO and is designed to be deployed as a secure operating system. This is the only supported method for deployment.

### Service Deployment

Following operating system installation, you can customize the service deployment by editing `/etc/rocknsm/rock/config.yml`.

**NOTE:** If this file does not exist, you can create it with the following command:

```
sudo /opt/rocknsm/rock/bin/generate_defaults.sh
```

Once you are happy with the deployment parameters, run the service deployment as follows:

```
sudo /opt/rocknsm/rock/bin/deploy_rock.sh
```

[![asciicast](https://asciinema.org/a/jnwhnl7N02G1bXbkot9zseirl.png)](https://asciinema.org/a/jnwhnl7N02G1bXbkot9zseirl)

### Functions Check:
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

## Thanks
This architecture is made possible by the efforts of an ever-growing list of amazing people. Look around our Github to see the whole list.
