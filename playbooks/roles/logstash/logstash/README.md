
# pires/logstash

I made this so that I could [easily cluster ELK on top of Kubernetes](https://github.com/pires/kubernetes-elk-cluster), and so, by default it will be listening for the [lumberjack](http://logstash.net/docs/1.4.2/inputs/lumberjack) protocol with certificates provisioned in a mounted directory, `/logstash/certs`.

## Current software

* Oracle JRE 8 Update 51
* Logstash 1.5.4
