# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.3"

  config.ssh.forward_agent = true
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'


  # Configure overall network interfaces
  #config.vm.network "public_network", bridge: "en4: Apple USB Ethernet Adapter", auto_config: false
  config.vm.network "public_network", bridge: "en0: Wi-Fi", auto_config: false
  #config.vm.network "private_network", auto_config: false

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8704
    vb.cpus   = 4
    vb.customize ["modifyvm", :id, "--nic1", "nat"]
    vb.customize ["modifyvm", :id, "--nic2", "hostonly"]
    vb.customize ["modifyvm", :id, "--hostonlyadapter2", "vboxnet0"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]

    # Forward exposed service ports - these are directly accesible on vmware
    #config.vm.network "forwarded_port", guest: 80, host: 8000
  end

  config.vm.provider "vmware_fusion" do |v|
    v.gui = "true"

    v.vmx["memsize"] = 8704
    v.vmx["numvcpus"] = 8
    v.vmx["ethernet0.present"] = "true"
    v.vmx["ethernet0.startConnected"] = "true"
    v.vmx["ethernet0.connectionType"] = "nat"
    v.vmx["ethernet1.present"] = "true"
    v.vmx["ethernet1.noPromisc"]  = "false"
    v.vmx["ethernet1.startConnected"] = "true"

    # Ensure vmware-tools are auto-updated when we update the kernel
    config.vm.provision "shell", inline: <<-SHELL
      sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
      sed -i 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations
    SHELL
  end

  # ansible required for ROCK 2.0 deployment
  # git required to clone ROCK repo
  # vim & tmux because of my sanity
  config.vm.provision "shell", inline: <<-SHELL
    yum -y install epel-release
    sed -i 's/^mirrorlist/#mirrorlist/; s/^#baseurl/baseurl/' /etc/yum.repos.d/{CentOS-Base.repo,epel.repo}
    yum -y update
    yum -y install ansible vim git tmux
  SHELL

  # Enable selinux
  config.vm.provision "shell", inline: <<-SHELL
    sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
    setenforce 1
  SHELL

end
