# Quick and Dirty DNS Server Setup

## Installing DNS in a virtual machine

1. Install CentOS
2. Install dnsmasq and dns tools (dig, nslookup, etc)
  ```bash
  yum install dnsmasq bind-utils -y
  systemctl enable dnsmasq
    ```
3. Update /etc/hosts with dns entries

  ```bash
  echo "1.2.3.4 myhostname.domain" >> /etc/hosts
  echo "4.3.2.1 coolsite.com coolsite" >> /etc/hosts
  echo "6.7.8.9 webapp" >> /etc/hosts
  # or an all in one command:
  cat << EOF >> /etc/hosts
  1.2.3.4 myhostname.domain
  4.3.2.1 coolsite.com coolsite
  6.7.8.9 webapp
  EOF
  ```
4. Allow DNS through the firewall
```bash
firewall-cmd --add-service dns
firewall-cmd --add-service dns --permanent
```
5. Update DNS settings to point to self
```bash
echo "nameserver 127.0.0.1" > /etc/resolv.conf
# Note: These settings can be overridden by NetworkManager. You might need to configure your network setting to assign a static DNS server to prevent this from being modified
# In CentOS, a relatively easy way to check and update this is through the nmtui tool
```
6. Test DNS
```bash
dig myhostname.domain
nslookup coolsite
```

## Using the existing DNS server when running VMware Workstation

If you are running VMware Workstation on a Linux host with the virtual machines network connection set to NAT then you can use the DHCP and DNS services provided by libvirtd's instance of dnsmasq. This is how you can use it:
1. Setup the virtual machine's network adapter to NAT
2. Add the NAT IP addresses of the virtual machine and hostnames to /etc/hosts on the machine running VMWare Workstation
3. Restart libvirtd with `systemctl restart libvirtd`
4. Verify it read your host file entries by looking at the status of the service and looking for the number of hosts read from /etc/hosts
5. Setup your virtual machines to use DHCP inside of the NAT network. This should automatically configure /etc/resolv.conf to point to the correct DNS server.
6. Test DNS inside of the virtual machines and from the host machine
