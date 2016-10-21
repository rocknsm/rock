# Setup installer
install
cdrom
text
skipx
firstboot --disabled
reboot

# Configure Storage
zerombr
clearpart --all --initlabel
autopart

# Configure OS
timezone UTC
lang en_US.UTF-8
keyboard us
network --bootproto=dhcp
unsupported_hardware
bootloader --location=mbr
services --enabled=ssh

# Users
rootpw vagrant
user --name=vagrant --plaintext --password vagrant

# Security
firewall --enabled --service=ssh
selinux --enforcing
auth --enableshadow --passalgo=sha512 --kickstart

%packages --excludedocs
%include packages.list
%end

%pre
%end

%post --nochroot --log=/mnt/sysimage/root/ks-post.log

# Save packages to local repo
mkdir -p /mnt/sysimage/srv/repo
rsync -rP --exclude 'TRANS.TBL' /mnt/install/repo/{Packages,repodata,support} /mnt/sysimage/srv/repo/

%end

%post --log=/root/ks-post-chroot.log
# sudo
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
sed -i "s/^[^#].*requiretty/#Defaults requiretty/" /etc/sudoers

%end
