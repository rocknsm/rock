FROM quay.io/pires/docker-logstash:1.5.4
MAINTAINER pjpires@gmail.com

# Logstash config
COPY config/logstash.conf /logstash/config/logstash.conf

# Copy certs for logstash.default.svc.cluster.local
COPY logstash-forwarder.crt /logstash/certs/logstash-forwarder.crt
COPY logstash-forwarder.key /logstash/certs/logstash-forwarder.key
