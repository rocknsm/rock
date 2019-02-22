# -*- mode: ruby -*-
# vi: set ft=ruby :

# This Vagrantfile is only for development testing!! Do not try to create a sensor
# using `vagrant up`. It's not going to do what you think it will do. That said
# If you have enough resources, you could feasibly playback PCAP on the dummy0
# interface and analyze the traffic
#
# THIS IS COMPLETELY UNSUPPORTED!
Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.ssh.forward_agent = true

  config.vm.provider "vmware_desktop" do |v|
    v.vmx["memsize"] = 16384
    v.vmx["numvcpus"] = 8
  end

  # ansible required for ROCK 2.0 deployment
  # git required to clone ROCK repo
  # vim & tmux because of my sanity
  config.vm.provision "shell", inline: <<-SHELL
    echo "tsflags=nodocs" | tee -a /etc/yum.conf
    yum -y install epel-release
    #sed -i 's/^mirrorlist/#mirrorlist/; s/^#baseurl/baseurl/' /etc/yum.repos.d/{CentOS-Base.repo,epel.repo}
    yum -y install https://packagecloud.io/rocknsm/2_3/packages/el/7/rock-release-2.3-1.noarch.rpm/download.rpm
    yum -y update
    yum -y install ansible vim git tmux tito
    # Create virtual interface
    ip link add dummy0 type dummy
    # Set the MTU to ludicrous mode
    ip link set dev dummy0 mtu 65521
    # Bring the interface up
    ip link set dummy0 up
  SHELL
end
