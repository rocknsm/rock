# Quick Start Guide
1. Install CentOS 64bit to a machine. For testing machines, minimum recommendation for hardware is:
* 8 GB RAM
* 2 processers
* 20 GB disk space
* 2 Network cards
2. Getting up and running from a fresh CentOS-7-x86_64-Minimal-1708.iso install (or other CentOS 64 bit images)
3. After getting a network connection run these commands to install updates and software then reboot:
```bash
yum update -y -q
yum install -y -q vim ansible open-vm-tools unzip git wget
reboot now
```
4. After the reboot and you log in, run these commands:
```bash
rm -rf /opt/rock
git clone -b <github_branch> <github_url> /opt/rock
/opt/rock/bin/generate_defaults.sh
cd /opt/rock/playbooks/
```
5. Choose the playbook file to run to start installing software
```bash
ansible-playbook <playbook_file>
```
