# Setup installer
install
cdrom
firstboot --disabled
#reboot --eject

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
# rootpw --lock --plaintext ROCKadmin!1234
# user --name=rockadmin --gecos='ROCK admin account' --groups wheel --plaintext --password ROCKadmin!1234

# Security
firewall --enabled --service=ssh
selinux --enforcing
auth --enableshadow --passalgo=sha512 --kickstart

%packages
%include packages.list
%end
#
# %pre
# #!/bin/bash
# PASS=$(shuf -n3 /srv/rocknsm/support/xkcd-dict.txt | sed 's/./\u&/' | tr -cd '[A-Za-z]')
#
# # Generate user information here
# cat << EOF > /tmp/ks-user.txt
# rootpw --lock --plaintext "${PASS}"
# user --name=rockadmin --gecos='ROCK admin account' --groups wheel --plaintext --password="${PASS}"
# EOF
#
# cat << EOF > /tmp/ks-pass.txt
# ${PASS}
# EOF
#
# %end

# This seems to get removed w/ ksflatten
%addon com_redhat_kdump --disable
%end

%post --nochroot --log=/mnt/sysimage/root/ks-post.log
#!/bin/bash
#
# # Save password
# mv /tmp/ks-pass.txt /mnt/sysimage/root/ks-pass.txt
# chmod 0600 /mnt/sysimage/root/ks-pass.txt
# cp /tmp/ks-user.txt /mnt/sysimage/root/ks-user.txt

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

# Default to offline build and generate values
mkdir -p /etc/rocknsm
cat << 'EOF' > /etc/rocknsm/config.yml
---
rock_online_install: False
EOF

/opt/rocknsm/ansible/generate_defaults.sh
#
# cat << 'EOF' > /etc/NetworkManager/dispatcher.d/99-firstboot-issue-update
# #!/bin/bash
#
# if [ -f /root/ks-pass.txt ]; then
# PASS=$(cat /root/ks-pass.txt)
# cat << EOS >> /etc/issue
# =====================================================
# Welcome to ROCK 2.0!
#
# We've taken the liberty to create an admin account
# and autogenerate a login password. Please login with
# the following:
#
#   Username: rockadmin
#   Password: ${PASS}
#
# To clear this message from loading on boot, delete
# the file /root/ks-pass.txt
# =====================================================
# EOS
#
# fi
#
# EOF

%end
