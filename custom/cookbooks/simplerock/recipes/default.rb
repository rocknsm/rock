#######################################################
##             Simple ROCK Build Recipe              ##
##                Provided by BroEZ                  ##
##         The EZ Network Security Monitor           ##
#######################################################

log 'branding' do
  message '
          Simple ROCK Automated Install Brought to You By:
======================================================================
                                 ,,     ]QQQyyy,;               
          ,,gQQQQQQ  QQERH@Qy #QB^^BQQ  @QQ  ``^h  QQQQy,,      
          @QQ ,,gQQ  @QygyQM  QQ    @Q  QQREBB       ,#QQR      
           QQ#^` `QQ |Q[ `QQg `BQQQQM^  QQQyyyg,   yQQM`        
           ]QQgQQQM^  ``                  . ``^T BQQQQy,,       
            ^`   ,,y#QQQQSBEERFHHHHHHFBEEBSQQQQQyy,  .`^P       
          ,gQQQMR^`    ,,,y   QQQQQQQQ~  y,,,    `^FBQQQy,      
         ]Q   ,y#Qyyy, `BQQQQ, QQQQQQ^,QQQQB` ,,yyQyy,   Q[     
         Q# ]QQQQQQQQQQQQyKQQQQ`QQQQUQQQQRyQQQQQQQQQQQQy @Q     
        Q#   ``^BQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQMH^`   @Q    
     ,QQR ,QQQQQQQyQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQgQQQQQQQy `QQy 
    @Q  yQQQQQQQQQQQQQQBB^ ```^BQQQQ#R``  `BBQQQQQQQQQQQQQQy  QQ
    ]Q    ,,yyQQQQQQQQy          @#          ,#QQQQQQQyy,,    QQ
     Qy @QQQQQQQQQQQQQQQR7QQQ          @QQL]QQQQQQQQQQQQQQQQ ]Qh
     QQ |QQQQQQQBEQQQQF   ROQ          QOR    YQQQQEBQQQQQQQh @Q 
     |Qp QQQR`,QQQQQQ^y                      g`QQQQQQy`HQQQ  Qh 
      @Q `^ yQQQQQQQQQ #                    y QQQQQQQQQy `h @Q  
       QQ  QQQQQQQQ}QQQQy                  y]QQQQQQQQQQQQ  ]Q^  
       ]Qp @QUQQQ# QQQQQQn;   |@QQQQ#L   g QQQQQQ @QQQRQ# .QL   
        %Q  ^QQQQ @QQQQQQQ      `@#^      QQQQQQQQ QQQQ`  QB    
         YQ  @QQh QQQ#QQQQ                {QQQ@QQQ  QQ#  QM     
          \Qy BQ ]QQQ QQQQ      ,QQy      QQQQ QQQ[ @M ,QR      
           1Qy ` @QQM QQQQQg ,#^    `@, ,QQQQQp]QQQ ` {QL       
             QQ  @Q# @Q#QQQQQL        `QQQQQ@QQ @Q#  #Q         
              YQy ` {QQ QQQQQ          QQQQQ QQQ ^ ;QR          
                @Q, YQ`{QQBQQQQQQ,,#QQQQQ\QQQ QR ,Q#            
                 `QQ,  QQQ QQQQQQQQQQQQQQ QQQ  ,QS^             
                   `@Qy `B QQQQQQQQQQQQQQ 5^ ,Q#^               
                     `BQy  `BQQQ@QQQQQQ#^  gQB                  
                        `BQy, `^QQQQ`` ,gQM^                    
                           `BQQy,  ,yQQB`                       
                               `HBBR`               TM    
======================================================================
                  The EZ Network Security Monitor
'
  level :info
  action :nothing
end

#######################################################
################# OS & Version Check ##################
#######################################################
## DEBUG
Chef::Log.debug(node['platform_family'])
Chef::Log.debug(node['platform_version'])

if node['platform_family'] != 'rhel'
  Chef::Log.fatal('This Cookbook is only meant for RHEL/CENTOS 7')
end

# Die if it's not CentOS/RHEL 7
raise if node['platform_family'] != 'rhel'
raise if not node['platform_version'] =~ /^7./

######################################################
################# Data Directory #####################
######################################################

###############
##### NOTE ####
###############
#You will want to remount this to your "good" storage after the build.  This is just to make sure all the paths in the configs are proper.
###############
directory '/data' do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

#######################################################
##################### Memory Info #####################
#######################################################
## Grab memory total from Ohai
total_memory = node['memory']['total']

## Ohai reports node[:memory][:total] in kB, as in "921756kB"
mem = total_memory.split("kB")[0].to_i / 1048576 # in GB

# Let's set a sane default in case ohai has decided to screw us.
node.run_state['es_mem'] = 4

if mem < 64
  # For systems with less than 32GB of system memory, we'll use half for Elasticsearch
  node.run_state['es_mem'] = mem / 2
else
  # Elasticsearch recommends not using more than 32GB for Elasticearch
  node.run_state['es_mem'] = 32
end

# We'll use es_mem later to do a "best effort" elasticsearch configuration

#######################################################
####################### CPU Info ######################
#######################################################
## Grab cpu total from Ohai
total_cpu = node['cpu']['total']

# Let's set a sane default in case ohai has decided to screw us.
node.run_state['bro_cpu'] = 2

if total_cpu <= 16
  # We'll use half the CPU's for bro, up to 8.
  node.run_state['bro_cpu'] = total_cpu / 2
else
  # I don't know what 64 bro processes run like, and I don't want to find out by surprise. We'll max at 8.
  node.run_state['bro_cpu'] = 8
end
#We'll use this in the bro node.cfg later.

######################################################
################### Configure Time ###################
######################################################
execute 'set_time_zone' do
  command 'timedatectl set-timezone UTC'
end

execute 'enable_ntp' do
  command 'timedatectl set-ntp yes'
end

######################################################
######### Determine the monitoring interface #########
######################################################
ohai "reload_network" do
  action :nothing
  plugin "network"
end

#Mod this to use the default interface: https://gist.github.com/dcode/358b5795e90c9d5ecb43
ruby_block 'determine_monitor_interface' do
  action :nothing
  block do
    node['network']['interfaces'].each do |iface, vals|
      next unless vals[:encapsulation].match('Ethernet')
      Chef::Log.debug("DEBUG #{iface}: Addr length of #{vals[:addresses].length}\n#{vals[:addresses]}")
      next if iface == 'lo'
      next if iface == node['network']['default_interface']
      #next unless vals[:addresses].length == 1
      node.run_state['monif'] = iface  
      ## DEBUG
      Chef::Log.debug("Using interface #{iface} for monitoring. \nDEBUG: Addr length of #{vals[:addresses].length}\n#{vals[:addresses]}")
      #Chef::Log.info("******** Using #{iface} (VAR: #{node.run_state['monif']}) for monitoring. ********")
    end
  end
  notifies :create, "template[/opt/bro/etc/node.cfg]", :delayed
  notifies :create, "template[ifcfg-monif]", :delayed
  notifies :create, "template[/sbin/ifup-local]", :delayed
end

#######################################################
#################### Disable IPv6 #####################
#######################################################
if File.readlines("/proc/sys/net/ipv6/conf/all/disable_ipv6").grep(/0/).size > 0 || File.readlines("/proc/sys/net/ipv6/conf/default/disable_ipv6").grep(/0/).size > 0

  execute 'ipv6_permanent_disable_1' do
    command 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
  end

  execute 'ipv6_permanent_disable_2' do
    command 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf'
  end

  execute 'ipv6_permanent_disable_3' do
    command 'sysctl -p'
  end

  execute 'ipv6_ephemeral_disable_all' do
    command 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6'
  end

  execute 'ipv6_ephemeral_disable_default' do
    command 'echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6'
  end

  execute 'ipv6_fix_sshd' do
    command 'sed -i "s/#AddressFamily any/AddressFamily inet/g" /etc/ssh/sshd_config'
  end

  execute 'ipv6_fix_sshd_restart' do
    command 'systemctl restart sshd'
  end
  
  execute 'ipv6_remove_localhost' do
    command 'sed -i "/^::1/d" /etc/hosts'
  end

  execute 'ipv6_fix_network_restart' do
    command 'systemctl restart network.service'
    notifies :reload, "ohai[reload_network]", :immediately
    notifies :run, resources("ruby_block[determine_monitor_interface]"), :delayed
  end
end

#######################################################
########### Add Monitor Interface File ################
#######################################################
template "ifcfg-monif" do
  path "/tmp/ifcfg_hacks.sh"
  source 'ifcfg_monif.erb'
  mode '0755'
  action :nothing
  notifies :run, "execute[ifcfg_hacks]", :delayed
end

execute 'ifcfg_hacks' do
  command "/tmp/ifcfg_hacks.sh"
  action :nothing
end

#Tune the capture interface, enable promiscuous mode at boot. 
template "/sbin/ifup-local" do
 source 'ifup-local.erb'
 owner 'root'
 group 'root'
 mode '0755'
 action :nothing
end

#######################################################
###################### DNS Fixes ######################
#######################################################
# This is only necessary because my local DNS isn't trustworthy.
execute 'add_google_dns' do
  command 'echo "nameserver 8.8.8.8" >> /etc/resolv.conf; echo "nameserver 8.8.4.4" >> /etc/resolv.conf'
  not_if 'grep 8.8.8.8 /etc/resolv.conf'
end

#######################################################
#################### Install EPEL #####################
#######################################################
package 'epel-release' do
  action :install
end

execute 'import_epel_key' do
  command 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'
end

#######################################################
################ Install ROCK Repos ###################
#######################################################
yum_repository 'simplerock' do
  description 'Simple ROCK Repo'
  baseurl 'https://pkgs.blackops.blue/rock/'
  gpgcheck false
  action :create
  sslverify false
end

#######################################################
################ Install NTOP Repos ###################
#######################################################
yum_repository 'ntop' do
  description 'ntop CentOS Repo'
  baseurl 'http://www.nmon.net/centos-stable/$releasever/$basearch/'
  gpgcheck true
  gpgkey 'http://www.nmon.net/centos-stable/RPM-GPG-KEY-deri'
  action :create
end

yum_repository 'ntop-noarch' do
  description 'ntop CentOS Repo - noarch'
  baseurl 'http://www.nmon.net/centos-stable/$releasever/noarch/'
  gpgcheck true
  gpgkey 'http://www.nmon.net/centos-stable/RPM-GPG-KEY-deri'
  action :create
end

execute 'import_ntop_key' do
  command 'rpm --import http://www.nmon.net/centos-stable/RPM-GPG-KEY-deri'
end

#######################################################
################## Build YUM Cache ####################
#######################################################
execute 'yum_makecache' do
  command 'yum makecache fast'
end

#######################################################
################## Schwack Packages ###################
#######################################################
package 'firewalld' do
  action :remove
end

package 'postfix' do
  action :remove
end

#######################################################
############### Install Core Packages #################
#######################################################
package ['tcpreplay', 'iptables-services', 'dkms', 'bro', 'broctl', 'bro-plugin-kafka-output', 'gperftools-libs', 'git', 'java-1.8.0-oracle', 'kafka', 'logstash', 'elasticsearch', 'nginx-spnego', 'jq', 'monit', 'policycoreutils-python', 'patch', 'vim', 'openssl-devel', 'zlib-devel', 'net-tools', 'lsof', 'htop', 'GeoIP-update', 'GeoIP-devel', 'GeoIP', 'kernel-devel', 'kernel-headers', 'kafkacat']

######################################################
################## Configure PF_RING #################
######################################################
#The damn ntop RPM doesn't create the config directory structure.
directory '/etc/pf_ring' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Enable PF_RING
file '/etc/pf_ring/pf_ring.start' do
  action :create
end

template '/etc/pf_ring/pf_ring.conf' do
  source 'pf_ring.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'pf_ring' do
  action [ :enable, :start ]
end

service 'cluster' do
  action :disable
end

######################################################
#################### Configure Bro ###################
######################################################
#Create bro data directories.
%w{logs spool}.each do |dir|
  directory "/data/bro/#{dir}" do
    mode '0755'
    owner 'root'
    group 'root'
    action :create
    recursive true
  end
end

#Start bro
execute 'start_bro' do
  command '/opt/bro/bin/broctl install; /opt/bro/bin/broctl check && /opt/bro/bin/broctl start'
  action :nothing
  notifies :write, "log[branding]", :delayed
end

#create /var/opt dirs
directory '/var/opt/bro/spool' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/var/opt/bro/logs' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Add custom scripts dir and readme.
directory '/opt/bro/share/bro/site/scripts' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/opt/bro/share/bro/site/scripts/readme.txt' do
  source 'bro_scripts_readme.txt.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Setup broctl.cfg
template '/opt/bro/etc/broctl.cfg' do
  source 'broctl.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Setup networks.cfg
template '/opt/bro/etc/networks.cfg' do
  source 'networks.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Setup node.cfg
template '/opt/bro/etc/node.cfg' do
  action :nothing
  source 'node.cfg.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, "execute[start_bro]", :delayed
end

# Setup local.bro
template '/opt/bro/share/bro/site/local.bro' do
  source 'local.bro.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

git '/opt/bro/share/bro/site/scripts/bro-file-extraction' do
  repository 'https://github.com/hosom/bro-file-extraction.git'
  revision 'master'
  action :sync
end

# Configure JSON logging
### This file will be dropped on the system, but not loaded.  This is for the "old way" where logstash picked up the files from disk.
template '/opt/bro/share/bro/site/scripts/json-logs.bro' do
  source 'json-logs.bro.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

######################################################
############### Reread Systemd Configs ###############
######################################################
execute 'reload_systemd' do
  command "systemctl daemon-reload"
  action :nothing
end

######################################################
################# Configure Zookeeper ################
######################################################
#Enable and start zookeeper
service 'zookeeper' do
  action [ :enable, :start ]  
end

######################################################
################### Configure Kafka ##################
######################################################
execute 'create_bro_topic' do
  command 'sleep 10; /opt/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic bro_raw'
  action :nothing
end

execute 'set_kafka_retention' do
  command 'sed -i "s/log.retention.hours=168/log.retention.hours=1/" /opt/kafka/config/server.properties'
end

#Enable and start kafka
service 'kafka' do
  action [ :enable, :start ]
  notifies :run, "execute[create_bro_topic]", :delayed
end

######################################################
################ Configure Elasticsearch #############
######################################################
#Create Data Directory
directory '/data/elasticsearch' do
  mode '0755'
  owner 'elasticsearch'
  group 'elasticsearch'
  action :create
end

template '/etc/sysconfig/elasticsearch' do
  source 'sysconfig_elasticsearch.erb'
end

template '/usr/lib/sysctl.d/elasticsearch.conf' do
  source 'sysctl.d_elasticsearch.conf.erb'
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'etc_elasticsearch.yml.erb'
end

template '/etc/security/limits.d/elasticsearch.conf' do
  source 'etc_limits.d_elasticsearch.conf.erb'
end

template '/usr/local/bin/es_cleanup.sh' do
  source 'es_cleanup.sh.erb'
  mode '0755'
end

execute '' do
  command 'sed -i "s/.*LimitMEMLOCK.*/LimitMEMLOCK=infinity/g" /usr/lib/systemd/system/elasticsearch.service'
end

service 'elasticsearch' do
  action [ :enable, :start ]  
end

bash 'install_marvel' do
  cwd '/usr/share/elasticsearch'
  code <<-EOH
    cd /usr/share/elasticsearch
    bin/plugin install elasticsearch/marvel/latest
    bin/plugin -u https://github.com/NLPchina/elasticsearch-sql/releases/download/1.4.5/elasticsearch-sql-1.4.5.zip --install sql
    /bin/systemctl restart elasticsearch
    /usr/bin/sleep 10
    /usr/local/bin/es_cleanup.sh
    EOH
end

######################################################
################## Configure Logstash ################
######################################################
execute 'set_logstash_ipv4_affinity' do
  command 'echo  "LS_JAVA_OPTS=\"-Djava.net.preferIPv4Stack=true\"" >> /etc/sysconfig/logstash'
end

template '/etc/logstash/conf.d/kafka-bro.conf' do
  source 'kafka-bro.conf.erb'
end

service 'logstash' do
  action [ :enable, :start ]
end

######################################################
################## Configure Kibana ##################
######################################################
remote_file "#{Chef::Config[:file_cache_path]}/kibana.tar.gz" do
  source 'https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz'
end

execute 'untar_kibana' do
  command "tar xzf #{Chef::Config[:file_cache_path]}/kibana.tar.gz -C /opt/"
end

execute 'rename_kibana_dir' do
  command 'mv /opt/{kibana-4.1.2-linux-x64,kibana}'
end

user 'kibana' do
  comment "kibana system user"
  home "/opt/kibana"
  manage_home false
  shell "/sbin/nologin"
  system true
  notifies :run, "execute[chown_kibana]", :immediately
end

execute 'chown_kibana' do
  command 'chown -R kibana:kibana /opt/kibana'
  action :nothing
end

template '/etc/systemd/system/kibana.service' do
  source 'kibana.service.erb'
  notifies :run, "execute[reload_systemd]", :immediately
end

service 'kibana' do
  action [ :enable, :start ]
end

######################################################
#################### Configure Cron ##################
######################################################
cron 'es_cleanup_cron' do
  hour '0'
  minute '1'
  command '/usr/local/bin/es_cleanup.sh >/dev/null 2>&1'
end

cron 'bro_cron' do
  minute '*/5'
  command '/opt/bro/bin/broctl cron >/dev/null 2>&1'
end

######################################################
############### Start/Stop/Status Scripts ############
######################################################
template '/usr/local/bin/rock_start' do
  source 'rock_start.erb'
  mode '0700'
  owner 'root'
  group 'root'
end

template '/usr/local/bin/rock_stop' do
  source 'rock_stop.erb'
  mode '0700'
  owner 'root'
  group 'root'
end

template '/usr/local/bin/rock_status' do
  source 'rock_status.erb'
  mode '0700'
  owner 'root'
  group 'root'
end

######################################################
######################## NGINX #######################
######################################################

# To be continued



