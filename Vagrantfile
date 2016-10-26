# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  #config.vm.box = "relativkreativ/centos-7-minimal"
  config.vm.box = "bento/centos-7.2"
  config.ssh.forward_agent = true
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.vm.network "forwarded_port", guest: 5601, host: 5601
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.network "private_network", auto_config: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus   = 4
    vb.customize ["modifyvm", :id, "--nic1", "nat"]
    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    vb.customize ["modifyvm", :id, "--hostonlyadapter2", "vboxnet0"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
  end

  config.vm.provider "vmware_fusion" do |v|
    v.linked_clone = true
    v.memory = 8192
    v.cpus   = 4
    v.vmx["ethernet1.noPromisc"]  = "false"
    v.vmx["ethernet2.noPromisc"]  = "false"
  end

  #config.vm.provision "shell", inline: <<-SHELL
     #hostnamectl set-hostname simplerockbuild.simplerock.lan
     #echo -e "127.0.0.2\tsimplerockbuild.simplerock.lan\tsimplerockbuild" >> /etc/hosts
#SHELL

  #config.vm.provision "chef_solo" do |chef|
  #  chef.log_level = "info"
  #  #chef.version = "12.3.0"
  #  chef.cookbooks_path = "cookbooks" # path to your cookbooks
  #  #chef.roles_path = "roles"
  #  chef.add_recipe "simplerock"
  #  #chef.node_name = "simplerockbuild"
  #end
end
