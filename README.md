## Response Operation Collections Kit Reference Build
----

This build was created and tested using CentOS 7. I pretty much guarantee that it won't work with anything else other than RHEL 7.

### Vagrant
NOTE:   
This Vagrantfile is configured to give the VM 8GB of RAM.  If your system can't do that you should buy a new system or adjust the `vm.memory` value.  Anything below 4 is going to run like poopoo.
``` 
git clone http://code.blackops.blue/jeff/simplerock.git
cd simplerock
vagrant up
```

### Physical/Virtual/Non-Vagrant
```
curl -O -k https://pkgs.blackops.blue/rock/chef-12.3.0-1.el6.x86_64.rpm
rpm -Uvh chef-12.3.0-1.el6.x86_64.rpm
yum install git -y
env GIT_SSL_NO_VERIFY=true git clone https://code.blackops.blue/jeff/simplerock.git
cd simplerock
chef-client -z -r "recipe[simplerock]"
```



