# Setup installer
install
cdrom
text
skipx
firstboot --disabled
reboot --eject

# Configure Storage
zerombr
clearpart --all --initlabel
autopart

# Configure OS
timezone UTC
lang en_US.UTF-8
keyboard us
network --bootproto=dhcp --noipv6 --activate
unsupported_hardware
bootloader --location=mbr
services --enabled=ssh

# Users
rootpw --lock --plaintext ROCKadmin!1234
user --name=rockadmin --gecos='ROCK admin account' --groups wheel --plaintext --password ROCKadmin!1234

# Security
firewall --enabled --service=ssh
selinux --enforcing
auth --enableshadow --passalgo=sha512 --kickstart

%packages --excludedocs
%include packages.list
%end

%pre
# Generate user information here
%end

%addon org_fedora_oscap
  content-type = scap-security-guide
  profile = stig-rhel7-server-upstream
%end

%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

%post --nochroot --log=/mnt/sysimage/root/ks-post.log

# Save packages to local repo
mkdir -p /mnt/sysimage/srv/rocknsm
rsync -rP --exclude 'TRANS.TBL' /mnt/install/repo/{Packages,repodata,support} /mnt/sysimage/srv/rocknsm/

%end

%post --log=/root/ks-post-chroot.log
#!/bin/bash

# Allow sudo w/ tools like ansible, etc
sed -i "s/^[^#].*requiretty/#Defaults requiretty/" /etc/sudoers

# Create local repository for ROCK NSM installation
cat << 'EOF' > /etc/yum.repos.d/rocknsm-local.repo
[rocknsm-local]
name=ROCKNSM Local Repository
baseurl=file:///srv/rocknsm
gpgcheck=0
enabled=1
# Prefer these packages versus online
cost=500
EOF

#######################################
# Extract current ROCK NSM scripts
#######################################
mkdir -p /opt/rocknsm
cd /opt/rocknsm
tar --extract --strip-components=1 --auto-compress --file=$(ls /srv/rocknsm/support/SimpleRock-*.tar.gz|head -1)
cd /opt/rocknsm/ansible; ./generate_defaults.sh

# Clean Up
rm -rf /root/hardening

# rc.local
# chmod +x /etc/rc.local

# cat << EOF >> /root/clean_up.sh
# #!/bin/bash
# ########################################
# # Delete Anaconda Kickstart
# ########################################
# if [ -e /root/anaconda-ks.cfg ]; then
# 	rm -f /root/anaconda-ks.cfg
# fi
#
# ########################################
# # Disable Pre-Linking
# # CCE-27078-5
# ########################################
# /usr/bin/sed -i 's/PRELINKING.*/PRELINKING=no/g' /etc/sysconfig/prelink
# /bin/chattr +i /etc/sysconfig/prelink
# /usr/sbin/prelink -ua &> /dev/null
#
# /usr/bin/sed -i '/clean_up.sh/d' /etc/rc.local
# rm -f /root/clean_up.sh
#
# exit 0
#
# EOF
# chmod 500 /root/clean_up.sh
# echo "/root/clean_up.sh" >> /etc/rc.local


%end
