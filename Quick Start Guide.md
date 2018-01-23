# Quick Start Guide
1. Install CentOS 64bit to a machine. For testing machines, minimum recommendation for hardware is:
* 8 GB RAM
* 2 processors
* 20 GB disk space
* 2 network cards

2. Getting up and running from a fresh CentOS-7-x86_64-Minimal-1708.iso install (or other CentOS 64 bit images)

3. After getting a network connection run these commands to install updates and software then reboot:
```bash
yum update -y -q
yum install -y -q vim ansible open-vm-tools git
reboot now
```

4. After the reboot, run these commands:
```bash
cp /etc/hosts /etc/hosts.bak
echo "127.0.0.1 rockserver1.lan" >> /etc/hosts
echo "127.0.0.1 rocksensor1.lan" >> /etc/hosts
rm -rf /opt/rock
git clone -b <github_branch> <github_url> /opt/rock
cd /opt/rock/playbooks
```

5. Make sure to make a snapshot before running ansible-playbook for the first time. This will allow you to revert to a non-modified CentOS machine since the playbooks do not clean up after themselves when running them more than once.

6. Start the installer using the "ansible-playbook" command:
```bash
ansible-playbook site.yml --ask-pass
```

7. To run only sensor/server related playbooks, use the "--limit" flag.
```bash
ansible-playbook site.yml --ask-pass --limit "sensors"
ansible-playbook site.yml --ask-pass --limit "servers"
```
