## Response Operation Collections Kit Reference Build
----

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
git clone http://code.blackops.blue/jeff/simplerock.git
git clone chef-solo -r ...
```
