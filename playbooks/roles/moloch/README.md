# Moloch Setup
## Build The Container
1. ```cd /operator/dip/dev/moloch```
2. ```docker-compose build```

## Use Moloch
> Moloch does not play nicely with docker-compose.
  It may not work properly with portainer templates, but is still manageable as acontainer

1. Setup the following directories with associated permissions
   ```
     mkdir -p /operator/dip/sensor/moloch/pcap && chown root:1000 ${_} && chmod 775 ${_}
     mkdir -p /operator/dip/sensor/moloch/log && chown root:1000 ${_} && chmod 775 ${_}
   ```
2. Link molochctl into your bin
   ```
     chmod 755 /operator/dip/dev/moloch/molochctl && ln -s ${_} /usr/bin
     molochctl
   ```
3. Ensure elasticsearch is running and reachable on docker.dmss:9200
4. ```cd /operator/dip/dev/moloch```
5. Initialize the Moloch user & elastic index using ```molochctl init``` & follow instructions
6. Start the capture using ```molochctl start capture```
7. Start the viewer with ```molochctl start viewer```
8. Navigate to http://docker.dmss:8005 in your web browser