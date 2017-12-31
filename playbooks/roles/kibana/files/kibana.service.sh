+[Unit]
 +Description = Kibana Container Service
 +
 +Wants    = network.target
 +Requires = docker.service
 +After	 = docker.service
 +
 +[Service]
 +Type = simple
 +
 +ExecStartPre = /usr/sbin/iptables -I INPUT 1 -p tcp --dport 5601 -j ACCEPT
 +ExecStart = /usr/bin/docker-compose -f /opt/rocknsm/kibana/kibana-compose.yml up
 +
 +ExecStop  = /usr/bin/docker-compose -f /opt/rocknsm/kibana/kibana-compose.yml down -v
 +ExecStop = /usr/sbin/iptables -D INPUT -p tcp --dport 5601 -j ACCEPT
 +
 +[Install]
 +WantedBy = multi-user.target
