ARG LOGSTASH_VERSION
FROM docker.elastic.co/logstash/logstash:${LOGSTASH_VERSION}
USER root
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-translate
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-tld
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-cidr
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-rest
RUN /usr/share/logstash/bin/logstash-plugin install logstash-codec-nmap
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
COPY log4j2.properties /usr/share/logstash/config/log4j2.properties
USER logstash
