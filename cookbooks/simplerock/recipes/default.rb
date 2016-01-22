#######################################################
##             Simple ROCK Build Recipe              ##
##   Provided by MOCYBER, BroEZ, & Critical Stack    ##
#######################################################

log 'branding' do
  message '
                                                Simple ROCK Automated Install Brought to You By:
=======================================================================================================================================================
                                                                                                                                                      
                                                                                                                 ,,      ]QQQQ#yyy,                   
                                    ,gppg,                                             ,,g#QQQQQ  @QQ#SRRQQ  yQQRRR@QQ,  @QQ``^^RRB   QQQQy,,         
                              ,sSS888888888USSg                                      |QQQ^`  @Q#  |QQ  ,,QQh]QQ     @QQ  QQQQQQQh       ``@QQQR^      
                         ,SSS88888888888888888888SSp,                                 @QQQQQSR@QQ, QQRRRQQ,  @QQ,,,yQQR  QQQ           ,QQQ#^         
                   ,sSS88888888888888888888888888888888SSp,                            QQQ    ,QQR @QQ   #RR   ^RRRR^   4RS#QQQQQQ   #QQ#R            
              ;SSS8888888888888888888888888888888888888888888SSo,                      @QQQQ##R^         ,,,,yyyyyyyyyy,,,,        `RRR#QQQQyy        
        ,sSS888888888888888888888888&R^^RSN888888888888888888888889SSg                 ^`    ,yy#QQQQQS#RRRRRRR^^^^^^RRRRRRRS#QQQQQ#yy,    `Rh        
   ,SSU88888888888888888888888&R^`           ^RR888888888888888888888888SSp          ,,yQQQQRRR^`     ,,,,  ·y########y   ,,,,     `^RBRQQQQy,        
  S8888888888888888888889R^`                       `^RS88888888888888888888Ry        QQ^`   ,yy,,   `R@QQQQQ `QQQQQQQS  #QQQQ#R   ,,,yy,   `^QQ       
 Q8888888888888888UR^`                                  ,|8888888888888888888y      jQ# ]QQQQQQQQQQQQQQ`@QQQQQ QQQQQQ @QQQQR,yQQQQQQQQQQQQQ  @Qp      
 88888888888UR^`                     ,-,,          ,SSS8888888888888888888888U      QQ  @QQQQQQQQQQQQQQQQQQQQQQ#QQQQQQQQQQyQQQQQQQQQQQQQQQQQ `QQ      
 88888888888                   ,sSSU888888USSpSSS8888888888888888888888888888U    yQ#  ,,,,, `R@QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ#R^ ,,,,, `@QQ    
 88888888888              ;SSS88888888888888888888888888888888888888888888888U yQQ#^ ,QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ#QQQQQQQQ#QQQQQQQQQQ  ?@QQy 
 88888888888             8888888888888888888888888888888888RR^   |88888888888U]QQ  ,QQQQQQQQQQQQQQQQQ#RR   ``^WQQQQQQR^`    RWSQQQQQQQQQQQQQQQQQ,  @Q 
 88888888888             N888888888888888888888888888&R^         |88888888888U QQ  ^   ,,Q@QQQQQQQQy,           KQQL           ,yQQQQQQQQQ,,,   `  QQ 
 88888888888             N88888888888888888888888888U            |88888888888U @Q  ,#QQQQQQQQQQQQQQQQQQBQyyy            yy##RQQQQQQQQQQQQQQQQQQQ  ]QQ 
 88888888888             N88888888888888888888888888h            |88888888888U |QQ ]QQQQQQQQQQQQQQQQQM  `RR^Y          F^RT  `@QQQQQQQQQQQQQQQQQh @Qh 
 88888888888             `*RS888888888888888888RR^               |88888888888U  QQ  QQQQQQ#R^Q#QQQQF                           `@QQQQyQ^R@QQQQQ#  QQ  
 88888888888                    `*RS88888RR^                     |88888888888U  @QQ ]QQR^ #QQQQQQQQ;R                          @Q@QQQQQQQy `WQQh @QR  
 88888888888S,                                               ,-SS888888888888U   QQ  R  #QQQQQQQQQQQ,#                        Q,@QQQQQQQQQQQ  R  QQ   
 888888888888888SSSg,                                  ,-SSS8888K888888888888U   ]QQ  ;QQQQQQQQQRQQQQh,Q                    @,@QQQQRQQQQQQQQQp  @Qh   
 88888888888shh9RRR8888SSp,                       -SSS8888RRhhhhh688888888888U    @QQ |QQ#@QQQQ @QQQQQQQ ,^  |QQ#yy#QQ   ^, @QQQQQQQ`QQQQQQQQh @QR    
 88888888888shhhhhhhh*9RR8888SSSg,          ;SSS888RRRhhhhhhhhhhh988888888888U     @QQ |R(QQQQ (QQQQQQQQ#      RQQQQR      @QQQQQQQQy`QQQQQ@R (QM     
 8888888888888#sjhhhhhhhhhh*9RRR8888SSSSSS888RRRhhhhhhhhhhhhjjs#U888888888888U      @Qy  QQQQh QQQQQQQQQ         ]R        |QQQQQQQQQ ]QQQQ  yQ#      
 88888888888888888U8#Njhhhhhhhhhhh9RRRRRRRhhhhhhhhhhhhjjs#U88888R888888888888U       @QQ ?QQ# ]QQQQNQQQQ         |Q        .QQQQRQQQQ  @QQh (Q#       
 88888888888shh9RRR88888U8#Njhhhhhhhhhhhhhhhhhhhjjs#888888RRUhhhh688888888888U        @QQ `Qh @QQQ#]QQQQQ      yQRRQy      @QQQQ @QQQQ ]Q  {QR        
 88888888888shhhhhhhh9RRR88888U##jhhhhhhhhhj8#888888RRRhhhhhhhhhh888888888888U         %QQ    QQQQ @QQQQQQ, ,#R     `BQ  ,QQQQQQQ QQQQ    @QR         
 88888888888U##jjhhhhhhhhhh99RR88888U###888888RRRhhhhhhhhhhhhj8#8888888888888U          ?QQ,  QQQh QQ#QQQQQQR          @QQQQQQ@QQ |QQQ  ,QQ^          
 88888888888888888U##jshhhhhhhhhh*9RRR88RRRhhhhhhhhhhhhj8#8888888888888888888R            @QQ  @R @QQhQQQQQQ           |QQQQQQ|QQQ %F  #QR            
  &888888888888888888888U##jshhhhhhhhhhhhhhhhhhhhj8#888888888888888888888888R              7QQ,  @QQR]QQQMQQQ#Q      #QQQQ@QQQ 7QQM  ,Q#^             
   ^R8888888888888888888888888U##jshhhhhhhhj8#8U8888888888888888888888888UR                  RQQ, 7^ QQQ#]QQQQQQQQ#QQQQQQQh@QQQ ?^ ,QQR               
        ^R&88888888888888888888888888###8U8888888888888888888888888UR^`                        BQQ, `@QQh]QQQQQQQQQQQQQQQQh]QQM  ,QQR                 
             `^RS88888888888888888888888888888888888888888888RRR^                                RQQQ  R  QQQQQQQQQQQQQQQQ ]R  yQQR                   
                   ^R&R888888888888888888888888888888888RR^                                        ?@QQ   %QQQQSQQQQ@QQQQR  ,#Q#^                     
                        `^RS8888888888888888888888UR^                                                 RQQy, `R@]QQQQM#R  ,#Q#R                        
                              `Y&88888888888RR^`                                                        `RQQQg  `RR`  yQQ#R                           
                                   `^RRRH^                                                                  ^BQQQyyQQ#R^                              
                                                                                                                `RT`                                  
=======================================================================================================================================================
'
  level :warn
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
package 'chrony' do
  action :install
end

execute 'set_time_zone' do
  command '/usr/bin/timedatectl set-timezone UTC'
end

execute 'enable_ntp' do
  command '/usr/bin/timedatectl set-ntp yes'
end

######################################################
############### Install Kernel Headers ###############
######################################################
## Necessary to make this pig run on RHEL:
execute 'enable_rhel_optional' do
  command 'subscription-manager repos --enable rhel-7-server-optional-rpms'
  only_if 'grep RHEL /etc/redhat-release'
end

execute 'enable_rhel_extras' do
  command 'subscription-manager repos --enable rhel-7-server-extras-rpms'
  only_if 'grep RHEL /etc/redhat-release'
end

execute 'enable_centos_cr' do
  command 'sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/CentOS-CR.repo'
  only_if 'grep CentOS /etc/redhat-release'
end

fullver = node['kernel']['release']
kernver = fullver.sub(".#{node['kernel']['machine']}", '')

package "kernel-devel" do
  version "#{kernver}"
  arch "#{node['kernel']['machine']}"
end

package "kernel-headers" do
  version "#{kernver}"
  arch "#{node['kernel']['machine']}"
end

######################################################
######### Determine the monitoring interface #########
######################################################
ohai "reload_network" do
  action :nothing
  plugin "network"
end

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
  notifies :create, "template[ifcfg-monif]", :delayed
  notifies :create, "template[/sbin/ifup-local]", :delayed
  notifies :create, "template[/etc/stenographer/config]", :delayed
  notifies :create, "template[/etc/sysconfig/snort]", :delayed
  notifies :create, "template[/opt/bro/etc/node.cfg]", :delayed
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

execute 'set_hostname' do
  command 'echo -e "127.0.0.2\tsimplerockbuild.simplerock.lan\tsimplerockbuild" >> /etc/hosts'
end

execute 'set_system_hostname' do
  command 'hostnamectl set-hostname simplerockbuild.simplerock.lan'
end

### TODO - This should come from somewhere else, not hard-coded.

#######################################################
#################### Install EPEL #####################
#######################################################
package 'epel-release' do
  action :install
  ignore_failure true
end

execute 'install_epel' do
  command 'rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
  not_if '[ $(rpm -qa epel-release | wc -l) -gt 0 ]'
end

execute 'import_epel_key' do
  command 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'
  only_if '[ -f /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 ]'
end

#######################################################
################ Install ROCK Repos ###################
#######################################################
yum_repository 'bintray_cyberdev' do
  description 'Bintray CyberDev Repo'
  baseurl 'https://dl.bintray.com/cyberdev/capes'
  gpgcheck false
  action :create
end

#######################################################
############### Install Elastic Repos #################
#######################################################
yum_repository 'logstash-2.1.x' do
  description 'Logstash repository for 2.1.x packages'
  baseurl 'http://packages.elastic.co/logstash/2.1/centos'
  gpgcheck true
  gpgkey 'http://packages.elastic.co/GPG-KEY-elasticsearch'
  action :create
end

yum_repository 'elasticsearch-2.x' do
  description 'Elasticsearch repository for 2.x packages'
  baseurl 'http://packages.elastic.co/elasticsearch/2.x/centos'
  gpgcheck true
  gpgkey 'http://packages.elastic.co/GPG-KEY-elasticsearch'
  action :create
end

#######################################################
################ Install NTOP Repos ###################
#######################################################
# Commented out 19JAN16 - version 6.2.0-425 was built against Myrinet and 
# was causing SimpleRock install to fail.  Moved 6.2.0-411 to bintray, pending investigation.

#yum_repository 'ntop' do
#  description 'ntop CentOS Repo'
#  baseurl 'http://packages.ntop.org/centos-stable/$releasever/$basearch/'
#  gpgcheck true
#  gpgkey 'http://packages.ntop.org/centos-stable/RPM-GPG-KEY-deri'
#  action :create
#end

#yum_repository 'ntop-noarch' do
#  description 'ntop CentOS Repo - noarch'
#  baseurl 'http://packages.ntop.org/centos-stable/$releasever/noarch/'
#  gpgcheck true
#  gpgkey 'http://packages.ntop.org/centos-stable/RPM-GPG-KEY-deri'
#  action :create
#end

execute 'import_ntop_key' do
  command 'rpm --import http://packages.ntop.org/centos-stable/RPM-GPG-KEY-deri'
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
package ['tcpreplay', 'iptables-services', 'dkms', 'bro', 'broctl', 'kafka-bro-plugin', 'gperftools-libs', 'git', 'java-1.8.0-oracle', 'kafka', 'logstash', 'elasticsearch', 'nginx-spnego', 'jq', 'policycoreutils-python', 'patch', 'vim', 'openssl-devel', 'zlib-devel', 'net-tools', 'lsof', 'htop', 'GeoIP-update', 'GeoIP-devel', 'GeoIP', 'kafkacat', 'stenographer', 'bats', 'nmap-ncat', 'snort', 'daq', 'perl-libwww-perl', 'perl-Crypt-SSLeay', 'perl-Archive-Tar', 'perl-Sys-Syslog', 'perl-LWP-Protocol-https']

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

# Convenience for the wandering analyst
%w{logs spool}.each do |dir|
  directory "/opt/bro/#{dir}" do
    action :delete
    recursive true
  end
  link "/opt/bro/#{dir}" do
    to "/data/bro/#{dir}"
  end
end

#Start bro
execute 'start_bro' do
  command '/opt/bro/bin/broctl install; /opt/bro/bin/broctl check && /opt/bro/bin/broctl start'
  action :nothing
  notifies :write, "log[branding]", :delayed
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
  repository 'https://github.com/CyberAnalyticDevTeam/bro-file-extraction.git'
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

template '/etc/profile.d/bro.sh' do
  source 'bro.sh.erb'
end

# Set capabilities for bro
execute 'set capabilities on bro' do
  command '/usr/sbin/setcap cap_net_raw,cap_net_admin=eip $(readlink -f /opt/bro/bin/bro)'
  not_if '/usr/sbin/setcap -v -q cap_net_raw,cap_net_admin=eip $(readlink -f /opt/bro/bin/bro)'
end

execute 'set capabilities on capstats' do
  command '/usr/sbin/setcap cap_net_raw,cap_net_admin=eip $(readlink -f /opt/bro/bin/capstats)'
  not_if '/usr/sbin/setcap -v -q cap_net_raw,cap_net_admin=eip $(readlink -f /opt/bro/bin/capstats)'
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

execute 'set_kafka_data_dir' do
  command 'sed -i "s|log.dirs=/tmp/kafka-logs|log.dirs=/data/kafka|g" /opt/kafka/config/server.properties'
end

directory '/data/kafka' do
  mode '0755'
  owner 'kafka'
  group 'kafka'
  action :create
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

execute 'set_es_memlock' do
  command 'sed -i "s/.*LimitMEMLOCK.*/LimitMEMLOCK=infinity/g" /usr/lib/systemd/system/elasticsearch.service'
end

service 'elasticsearch' do
  action [ :enable, :start ]  
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

execute 'update_kafka_input_plugin' do
  command 'cd /opt/logstash; sudo bin/plugin install --version 2.0.3 logstash-input-kafka'
end

service 'logstash' do
  action [ :enable, :start ]
end

######################################################
################## Configure Kibana ##################
######################################################
remote_file "#{Chef::Config[:file_cache_path]}/kibana.tar.gz" do
  source 'https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz'
  not_if 'cat /opt/kibana/package.json | jq \'.version\' | grep 4.3.1'
end

execute 'untar_kibana' do
  command "tar xzf #{Chef::Config[:file_cache_path]}/kibana.tar.gz -C /opt/"
  not_if 'ls /opt/kibana'
end

execute 'rename_kibana_dir' do
  command 'mv /opt/{kibana-4.3.1-linux-x64,kibana}'
  not_if 'ls /opt/kibana'
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
  not_if 'ls -ld /opt/kibana/optimize | grep -q "kibana kibana"'
end

template '/etc/systemd/system/kibana.service' do
  source 'kibana.service.erb'
  notifies :run, "execute[reload_systemd]", :immediately
end

bash 'set_kibana_replicas' do
  code <<-EOH
  curl -XPUT localhost:9200/_template/kibana-config -d ' {
   "order" : 0,
   "template" : ".kibana",
   "settings" : {
     "index.number_of_replicas" : "0",
     "index.number_of_shards" : "1"
   },
   "mappings" : { },
   "aliases" : { }
  }'
 EOH
end

service 'kibana' do
  action [ :enable, :start ]
end


######################################################
################## Configure Marvel ##################
######################################################
bash 'install_marvel_and_sql' do
  cwd '/usr/share/elasticsearch'
  code <<-EOH
    # Install ES components
    cd /usr/share/elasticsearch
    bin/plugin install license
    bin/plugin install marvel-agent
    bin/plugin install https://github.com/NLPchina/elasticsearch-sql/releases/download/2.1.1/elasticsearch-sql-2.1.1.zip 
    bin/plugin install royrusso/elasticsearch-HQ
    systemctl daemon-reload
    /bin/systemctl restart elasticsearch
    /usr/bin/sleep 10
    /usr/local/bin/es_cleanup.sh
    # Install kibana component
    cd /opt/kibana
    bin/kibana plugin --install elasticsearch/marvel/latest
    /bin/systemctl restart kibana
    /usr/bin/sleep 5
    EOH
end

#Offline Install
#bin/plugin install file:///path/to/file/license-2.1.0.zip
#bin/plugin install file:///path/to/file/marvel-agent-2.1.0.zip
#bin/kibana plugin --install marvel --url file:///path/to/file/marvel-2.1.0.tar.gz

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
############### Configure Stenographer ###############
######################################################
template '/etc/stenographer/config' do
  source 'etc_stenographer_config.erb'
  action :nothing
end

directory '/data/stenographer' do
  mode '0755'
  owner 'stenographer'
  group 'stenographer'
  action :create
end

%w{index packets}.each do |dir|
  directory "/data/stenographer/#{dir}" do
    mode '0755'
    owner 'stenographer'
    group 'stenographer'
    action :create
    recursive true
  end
end

#Stenographer configured, but disabled by default.
service 'stenographer' do
  action :disable
end

######################################################
######################## NGINX #######################
######################################################
template '/etc/nginx/conf.d/rock.conf' do
  source 'rock.conf.erb'
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

file '/etc/nginx/conf.d/example_ssl.conf' do
  action :delete
end

execute 'enable_nginx_connect_selinux' do
  command 'setsebool -P httpd_can_network_connect 1'
end

service 'nginx' do
  action [ :enable, :start ]
end

######################################################
######################## SNORT #######################
######################################################
# Temaplate in the various snort config files
template '/etc/sysconfig/snort' do
  source 'snort.erb'
  action :nothing
  notifies :run, "bash[run_pulledpork]", :immediately 
end

template '/etc/snort/snort.conf' do
  source 'snort.conf.erb'
end

template '/etc/snort/disablesid.conf' do
  source 'disablesid.conf.erb'
end

template '/etc/snort/pulledpork.conf' do
  source 'pulledpork.conf.erb'
end

# Set snort capabilities
execute 'set capabilities on snort' do
  command '/usr/sbin/setcap cap_net_raw,cap_net_admin=eip $(readlink -f /usr/sbin/snort)'
  not_if '/usr/sbin/setcap -v -q cap_net_raw,cap_net_admin=eip $(readlink -f /usr/sbin/snort)'
end

# ROCK Bro Scripts  !!!TODO!!! This should probably be moved to the BRO section later. 
git '/opt/bro/share/bro/site/scripts/rock' do
  repository 'https://github.com/CyberAnalyticDevTeam/rock_bro_scripts.git'
  revision 'master'
  action :sync
end

# Install pulledpork  !!!TODO!!! pulledpork should probably be moved to /opt/pulledpork for consistency
git '/usr/local/pulledpork' do
  repository 'https://github.com/shirkdog/pulledpork.git'
  revision 'master'
  action :sync
end

execute 'chmod_pulledpork' do
  command 'chmod 755 /usr/local/pulledpork/pulledpork.pl' 
end

#`ln -s /usr/local/pulledpork/pulledpork.pl /usr/local/bin/pulledpork.pl`
link '/usr/local/bin/pulledpork.pl' do
  to '/usr/local/pulledpork/pulledpork.pl'
end

#`mkdir /usr/lib/snort_dynamicrules/; chmod 755 /usr/lib/snort_dynamicrules/; chown root:root /usr/lib/snort_dynamicrules/`
directory '/usr/lib/snort_dynamicrules' do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

#`mkdir /etc/snort/rules/iplists`
directory '/etc/snort/rules/iplists' do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

#`touch /etc/snort/rules/local.rules`
file '/etc/snort/rules/local.rules' do
  action :create
end

#`touch /etc/snort/rules/{black,white}_list.rules`
file '/etc/snort/rules/white_list.rules' do
  action :create
end

file '/etc/snort/rules/black_list.rules' do
  action :create
end

#`mkdir /data/snort; chown snort:snort /data/snort`
directory '/data/snort' do
  mode '0755'
  owner 'snort'
  group 'snort'
  action :create
end

execute 'snort_chcon' do
  command 'chcon -v --type=snort_log_t /data/snort/'
end

# Run pulledpork
bash 'run_pulledpork' do
  code <<-EOH
  /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l;
  /usr/bin/systemctl restart snortd
  EOH
  action :nothing
end

# Add pulledpork cron
cron 'pulledpork' do
  hour '12'
  minute '0'
  command "/usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l > /var/log/snort/pulledpork.log 2>&1 && /usr/bin/systemctl restart snortd"
end



# To be continued



