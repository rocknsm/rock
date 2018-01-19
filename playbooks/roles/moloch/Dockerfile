FROM centos:bluefin

USER root
WORKDIR /data/moloch

COPY etc/ etc/

RUN yum -y update \
 && yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm \
 && yum -y install https://files.molo.ch/builds/centos-7/moloch-0.19.1-1.x86_64.rpm \
 && yum -y install net-tools libpng-devel bzip2 gcc-c++ \           
 && chmod 644 etc/GeoIP.dat \
              etc/GeoIPASNum.dat \
              etc/GeoIPASNumv6.dat \
              etc/GeoIPv6.dat \
              etc/ipv4-address-space.csv \
 && chmod 664 etc/config.ini \              
 && cd viewer \
 && ../bin/npm install \
 && ../bin/npm update
  
EXPOSE  8005