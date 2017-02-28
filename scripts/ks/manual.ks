# Setup installer
install
cdrom
firstboot --disabled
eula --agreed
#reboot --eject

# Configure OS
timezone UTC
lang en_US.UTF-8
keyboard us
network --bootproto=dhcp --noipv6 --activate
unsupported_hardware

services --enabled=ssh

# Users
rootpw --lock
#user --name=rockadmin --gecos='ROCK admin account' --groups=wheel

# Security
firewall --enabled --service=ssh
selinux --enforcing
auth --enableshadow --passalgo=sha512 --kickstart

%packages
%include packages.list
%end

# This seems to get removed w/ ksflatten
%addon com_redhat_kdump --disable
%end

%post --nochroot --log=/mnt/sysimage/root/ks-post.log
#!/bin/bash

# Save packages to local repo
mkdir -p /mnt/sysimage/srv/rocknsm
rsync -rP --exclude 'TRANS.TBL' /mnt/install/repo/{Packages,repodata,support} /mnt/sysimage/srv/rocknsm/

%end

%post --log=/root/ks-post-chroot.log
#!/bin/bash

ROCK_DIR=/opt/rocknsm/rock

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
mkdir -p ${ROCK_DIR}; cd ${ROCK_DIR}
tar --extract --strip-components=1 --auto-compress --file=$(ls /srv/rocknsm/support/rock_*.tar.gz|head -1)

# Default to offline build and generate values
mkdir -p /etc/rocknsm
cat << 'EOF' > /etc/rocknsm/config.yml
---
rock_online_install: False
EOF

${ROCK_DIR}/ansible/generate_defaults.sh

# Install /etc/issue updater
cp ${ROCK_DIR}/ansible/files/etc-issue.in /etc/issue.in
cp ${ROCK_DIR}/ansible/files/nm-issue-update /etc/NetworkManager/dispatcher.d/50-rocknsm-issue-update
chmod 755 /etc/NetworkManager/dispatcher.d/50-rocknsm-issue-update

%end
