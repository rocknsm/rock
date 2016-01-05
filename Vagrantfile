# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "relativkreativ/centos-7-minimal"
  config.vm.network "forwarded_port", guest: 5601, host: 5601
  config.vm.network "forwarded_port", guest: 9200, host: 9200
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus   = 4
    vb.customize ["modifyvm", :id, "--nic1", "nat"]
    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    vb.customize ["modifyvm", :id, "--hostonlyadapter2", "vboxnet0"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
  end

  #config.vm.provision "shell", inline: <<-SHELL
     #hostnamectl set-hostname simplerockbuild.simplerock.lan
     #echo -e "127.0.0.2\tsimplerockbuild.simplerock.lan\tsimplerockbuild" >> /etc/hosts
#SHELL

  config.vm.provision "chef_solo" do |chef|
    chef.log_level = "info"
    chef.version = "12.3.0"
    chef.cookbooks_path = "cookbooks" # path to your cookbooks
    #chef.roles_path = "roles"
    chef.add_recipe "simplerock"
    #chef.node_name = "simplerockbuild"
  end
end
