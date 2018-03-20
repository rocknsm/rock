Logstash
=========

Central database for managing all Rock data.

<h1> [Event Data](https://www.elastic.co/guide/en/logstash/current/event-dependent-configuration.html)</h1>

<h2> Fields</h2>

All events have properties. For example, an apache access log would have things like status code (200, 404), request path ("/", "index.html"), HTTP verb (GET, POST), client IP address, etc. Logstash calls these properties "fields."

<h3> Field References</h3>

It is often useful to be able to refer to a field by name. To do this, you can use the Logstash field reference syntax.

The syntax to access a field is [fieldname]. If you are referring to a top-level field, you can omit the [] and simply use fieldname. To refer to a nested field, you specify the full path to that field: [top-level field][nested field].

For example, the following event has five top-level fields (agent, ip, request, response, ua) and three nested fields (status, bytes, os).

```
{
  "agent": "Mozilla/5.0 (compatible; MSIE 9.0)",
  "ip": "192.168.24.44",
  "request": "/index.html"
  "response": {
    "status": 200,
    "bytes": 52353
  },
  "ua": {
    "os": "Windows 7"
  }
}
```

<h4> sprintf format</h4>

The field reference format is also used in what Logstash calls sprintf format. This format enables you to refer to field values from within other strings. For example, the statsd output has an increment setting that enables you to keep a count of apache logs by status code:
```
output {
  statsd {
    increment => "apache.%{[response][status]}"
  }
}
```
Similarly, you can convert the timestamp in the @timestamp field into a string. Instead of specifying a field name inside the curly braces, use the +FORMAT syntax where FORMAT is a time format.

For example, if you want to use the file output to write to logs based on the event’s date and hour and the type field:
```
output {
  file {
    path => "/var/log/%{type}.%{+yyyy.MM.dd.HH}"
  }
}
```
<h1> Pipeline</h1>

<h2>Input</h2>

Defines where the logs are coming from. Ex:

```
beats {
    port => "5044"
}
```

You use inputs to get data into Logstash. Some of the more commonly-used inputs are:

- file: reads from a file on the filesystem, much like the UNIX command tail -0F
- syslog: listens on the well-known port 514 for syslog messages and parses according to the RFC3164 format
- redis: reads from a redis server, using both redis channels and redis lists. Redis is often used as a "broker" in a centralized Logstash installation, which queues Logstash events from remote Logstash "shippers".
- beats: processes events sent by Filebeat.

For more information about the available inputs, see: https://www.elastic.co/guide/en/logstash/current/input-plugins.html

<h2>Filter</h2>

<h3> Description</h3>

```
filter {
   grok {
       match => { "message" => "%{COMBINEDAPACHELOG}"}
   }
   geoip {
       source => "clientip"
   }
```

You can have a filter section like this which means use the grok plugin, affix the name message to the incoming log, and apply the COMBINEDAPACHELOG pattern to it. It then also passes everything through the geoip plugin based on the incoming clientip field which is a part of the JSON output by the COMBINEDAPACHELOG pattern.

The finalized event looks like this:

```
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
```

<h3> Grok</h3>

Grok works by combining text patterns into something that matches your logs.

The syntax for a grok pattern is %{SYNTAX:SEMANTIC}

The SYNTAX is the name of the pattern that will match your text. For example, 3.44 will be matched by the NUMBER pattern and 55.3.244.1 will be matched by the IP pattern. The syntax is how you match.

The SEMANTIC is the identifier you give to the piece of text being matched. For example, 3.44 could be the duration of an event, so you could call it simply duration. Further, a string 55.3.244.1 might identify the client making a request.

For the above example, your grok filter would look something like this:

``%{NUMBER:duration} %{IP:client}``

<h2>Output</h2>

Defines where the logs are output to. For example:

`stdout { codec => rubydebug }`

<h4> Elasticsearch Output</h4>

You can output to elasticsearch with something like:

```
output {
    elasticsearch {
        hosts => [ "localhost:9200" ]
    }
}
```

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


Helpful Commands
----------------

Check your configuration:
bin/logstash -f first-pipeline.conf --config.test_and_exit
The --config.reload.automatic option enables automatic config reloading so that you don’t have to stop and restart Logstash every time you modify the configuration file.
