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
4. After the reboot and you log in, run these commands:
```bash
rm -rf /opt/rock
git clone -b <github_branch> <github_url> /opt/rock
/opt/rock/bin/generate_defaults.sh
```
5. Make sure to make a snapshot before running the deploy_rock script for the first time. This will allow you to revert to a non-modified CentOS machine since the playbooks do not clean up after themselves when running them more than once.
6. If necessary, change the software being included in the /opt/rock/playbooks/inventory.yml
7. Run the deploy script and choose the appropriate option
```bash
/opt/rock/bin/deploy_rock.sh
```
