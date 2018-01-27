# Getting CentOS Repos Working on RedHat
1. Create /etc/yum.repos.d/CentOS-Base.repo for CentOS (note: this repo file was taken from a CentOS-7 (1708) image with the $releasever variable being hard-coded to the number 7)

  ```bash
  cat << 'EOF' > /etc/yum.repos.d/CentOS-Base.repo
  # CentOS-Base.repo
  #
  # The mirror system uses the connecting IP address of the client and the
  # update status of each mirror to pick mirrors that are updated to and
  # geographically close to the client.  You should use this for CentOS updates
  # unless you are manually picking other mirrors.
  #
  # If the mirrorlist= does not work for you, as a fall back you can try the
  # remarked out baseurl= line instead.
  #
  #

  [base]
  name=CentOS-7 - Base
  mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=os&infra=$infra
  #baseurl=http://mirror.centos.org/centos/7/os/$basearch/
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

  #released updates
  [updates]
  name=CentOS-7 - Updates
  mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=updates&infra=$infra
  #baseurl=http://mirror.centos.org/centos/7/updates/$basearch/
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

  #additional packages that may be useful
  [extras]
  name=CentOS-7 - Extras
  mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=extras&infra=$infra
  #baseurl=http://mirror.centos.org/centos/7/extras/$basearch/
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

  #additional packages that extend functionality of existing packages
  [centosplus]
  name=CentOS-7 - Plus
  mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=centosplus&infra=$infra
  #baseurl=http://mirror.centos.org/centos/7/centosplus/$basearch/
  gpgcheck=1
  enabled=0
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
  EOF
  ```

2. Install the CentOS 7 GPG keys
  ```bash
  # If the file doesn't exist, download it
  if [ ! -f /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ]; then
      wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-7 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
  fi
  # Then import it
  gpg --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
  ```

3. Clean the yum cache and verify the repos are listed
  ```bash
  yum clean all
  yum repolist all
  # You should see these entries with numbers similar to these:
  # repo id           repo name       status
  # base/x86_64       CentOS-7Client  enabled:  9,591
  # centosplus/x86_64 CentOS-7Client  disabled
  # extras/x86_64     CentOS-7Client  enabled:    329
  # updates/x86_64    CentOS-7Client  enabled:  1,909
  ```

4. If the RedHat subscription manager is causing your problems, you can disable it by turning off yum plugins:
  ```bash
  sed -i 's/plugins=1/plugins=0/g' /etc/yum.conf
  ```
  you might also need to run this command to fully turn it off:
  ```bash
  subscription-manager config --rhsm.manage_repos=0
  ```
