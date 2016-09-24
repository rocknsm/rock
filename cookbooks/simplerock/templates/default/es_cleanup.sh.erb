#!/bin/bash

#Clean out old marvel indexes, only keeping the current index.
for i in $(curl -sSL http://localhost:9200/_stats/indexes\?pretty\=1 | grep marvel | grep -Ev 'es-data|kibana' | grep -vF "$(date +%m.%d)" | awk '{print $1}' | sed 's/\"//g' 2>/dev/null); do
  curl -sSL -XDELETE http://127.0.0.1:9200/$i > /dev/null 2>&1
done

#Cleanup TopBeats indexes from 5 days ago.
#curl -sSL -XDELETE "http://127.0.0.1:9200/topbeat-$(date -d '5 days ago' +%Y.%m.%d)" 2>&1

#Delete Logstash indexes from 60 days ago.
curl -sSL -XDELETE "http://127.0.0.1:9200/logstash-$(date -d '60 days ago' +%Y.%m.%d)" 2>&1

#Close Logstash indexes from 15 days ago.
curl -XPOST "http://127.0.0.1:9200/logstash-$(date -d '15 days ago' +%Y.%m.%d)/_close" 2>&1

#Make sure all indexes have replicas off
curl -sSL -XPUT 'localhost:9200/_all/_settings' -d '
{
    "index" : {
        "number_of_replicas" : 0
    }
}' > /dev/null 2>&1
