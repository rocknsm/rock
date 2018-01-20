Logstash
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

None



Input
-----
Defines where the logs are coming from. Ex:

beats {
    port => "5044"
}

You use inputs to get data into Logstash. Some of the more commonly-used inputs are:

- file: reads from a file on the filesystem, much like the UNIX command tail -0F
- syslog: listens on the well-known port 514 for syslog messages and parses according to the RFC3164 format
- redis: reads from a redis server, using both redis channels and redis lists. Redis is often used as a "broker" in a centralized Logstash installation, which queues Logstash events from remote Logstash "shippers".
- beats: processes events sent by Filebeat.

For more information about the available inputs, see https://www.elastic.co/guide/en/logstash/current/input-plugins.html

Filter
------

Output
------
Defines where the logs are output to. For example:

stdout { codec => rubydebug }

Elasticsearch Output
********************

You can output to elasticsearch with something like:
output {
    elasticsearch {
        hosts => [ "localhost:9200" ]
    }
}

Filters
-------

filter {
   grok {
       match => { "message" => "%{COMBINEDAPACHELOG}"}
   }
   geoip {
       source => "clientip"
   }

You can have a filter section like this which means use the grok plugin, affix the name message to the incoming log, and apply the COMBINEDAPACHELOG pattern to it. It then also passes everything through the geoip plugin based on the incoming clientip field which is a part of the JSON output by the COMBINEDAPACHELOG pattern.

The finalized event looks like this:

{
        "request" => "/presentations/logstash-monitorama-2013/images/kibana-search.png",
          "agent" => "\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36\"",
          "geoip" => {
              "timezone" => "Europe/Moscow",
                    "ip" => "83.149.9.216",
              "latitude" => 55.7485,
        "continent_code" => "EU",
             "city_name" => "Moscow",
          "country_name" => "Russia",
         "country_code2" => "RU",
         "country_code3" => "RU",
           "region_name" => "Moscow",
              "location" => {
            "lon" => 37.6184,
            "lat" => 55.7485
        },
           "postal_code" => "101194",
           "region_code" => "MOW",
             "longitude" => 37.6184
    },

Codecs
------
Codecs are basically stream filters that can operate as part of an input or output. Codecs enable you to easily separate the transport of your messages from the serialization process. Popular codecs include json, msgpack, and plain (text).

- json: encode or decode data in the JSON format.
- multiline: merge multiple-line text events such as java exception and stacktrace messages into a single event.

For more information about the available codecs, see https://www.elastic.co/guide/en/logstash/current/codec-plugins.html

Logstash Docker Directory Layout
--------------------------------
https://www.elastic.co/guide/en/logstash/current/dir-layout.html#docker-layout

Configuring Logstash for Docker
------------------------------
https://www.elastic.co/guide/en/logstash/current/_configuring_logstash_for_docker.html

Settings File
-------------
https://www.elastic.co/guide/en/logstash/current/logstash-settings-file.html

Other Helpful Tips
------------------
- Logstash will concatenate all configuration files together. In our case, logstash-kafka-bro.conf, logstash-kafka-fsf.conf, and logstash-kafka-suricata.conf will all be concatenated together in lexigraphical order into a single config file. See the -f command line option.

Kafka Plugin
------------


Helpful Commands
----------------

Check your configuration:
bin/logstash -f first-pipeline.conf --config.test_and_exit
The --config.reload.automatic option enables automatic config reloading so that you don’t have to stop and restart Logstash every time you modify the configuration file.
