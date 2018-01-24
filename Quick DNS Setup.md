# Quick and Dirty DNS Servers

## Install CentOS
## Install dnsmasq and dns tools (dig, nslookup, etc)
```bash
yum install dnsmasq bind-utils -y
systemctl enable dnsmasq
```
## Update /etc/hosts with dns entries

```bash
echo "1.2.3.4 myhostname.domain" >> /etc/hosts
echo "4.3.2.1 coolsite.com coolsite" >> /etc/hosts
echo "6.7.8.9 webapp" >> /etc/hosts
```
## Allow DNS through the firewall
```bash
firewall-cmd --add-service dns
firewall-cmd --add-service dns --permanent
```
## Update DNS settings to point to self
```bash
echo "nameserver 127.0.0.1" > /etc/resolv.conf
# Note: These settings can be overridden by NetworkManager. You might need to configure your network setting to assign a static DNS server to prevent this from being modified
```
## Test DNS
```bash
dig myhostname.domain
nslookup coolsite
```
