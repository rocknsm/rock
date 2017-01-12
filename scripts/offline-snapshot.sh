#!/bin/bash

ROCK_CACHE_DIR=/srv/rocknsm
ROCK_REPO=dev
ROCKSCRIPTS_BRANCH=devel
ROCKDASHBOARDS_BRANCH=master
ROCK_BRANCH=devel
PULLEDPORK_RELEASE=0.7.2
TMP_RPM_ROOT=$(mktemp -d)

function cleanup-snapshot () {
  rm -rf ${TMP_RPM_ROOT}
}

trap cleanup-snapshot EXIT

function offline-snapshot () {

  # Requires to run as root
  if [ $(id -u) != 0 ]; then echo "Run this script as root (try sudo)"; exit 1; fi

  # Add repo file for rocksnm repo content
  cat << EOF > /etc/yum.repos.d/rock-offline.repo
[rocknsm_dev]
name=rocknsm_dev
baseurl=https://packagecloud.io/rocknsm/${ROCK_REPO}/el/7/\$basearch
repo_gpgcheck=1
enabled=1
gpgkey=https://packagecloud.io/rocknsm/${ROCK_REPO}/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[elastic-5.x]
baseurl = https://artifacts.elastic.co/packages/5.x/yum
gpgcheck = 0
gpgkey = https://artifacts.elastic.co/GPG-KEY-elasticsearch
name = Elastic Stack repository for 5.x

[epel]
baseurl = http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch/
gpgcheck = 1
gpgkey = https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
name = EPEL YUM repo

[elrepo-kernel]
name=ELRepo.org Community Enterprise Linux Kernel Repository - el7
baseurl=http://elrepo.org/linux/kernel/el7/\$basearch/
gpgcheck=1
gpgkey=https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
protect=0
EOF

  mkdir -p "${ROCK_CACHE_DIR}/Packages"

  # Update metadata cache
  yum makecache -y fast

  # Download minimal set of packages for kickstart
  grep -vE '^[%#-]|^$' ks/packages.list | \
    awk '{print$1}' | \
    xargs sudo yum install --downloadonly --releasever=/ \
      --downloaddir=${ROCK_CACHE_DIR}/Packages/ \
      --installroot=${TMP_RPM_ROOT}

  # Download rock packages for later install
  grep -vE '^[%#-]|^$' ks/rock_packages.list | \
    awk '{print$1}' | \
    xargs sudo yum install --downloadonly --releasever=/ \
      --downloaddir=${ROCK_CACHE_DIR}/Packages/ \
      --installroot=${TMP_RPM_ROOT}

  # Add packages needed for anaconda
  grep -vE '^[%#-]|^$' ks/installer_packages.list | \
    awk '{print$1}' | \
    xargs sudo yum install --downloadonly --releasever=/ \
      --downloaddir=${ROCK_CACHE_DIR}/Packages/ \
      --installroot=${TMP_RPM_ROOT}

  # Clear old repo data & generate fresh
  rm -rf ${ROCK_CACHE_DIR}/repodata
  createrepo ${ROCK_CACHE_DIR}

  mkdir -p "${ROCK_CACHE_DIR}/support"
  pushd "${ROCK_CACHE_DIR}/support" >/dev/null

  echo "Downloading ET Snort rules..."
  # ET Rules - Snort
  curl -Ls -o emerging.rules-snort.tar.gz \
    'https://rules.emergingthreats.net/open/snort-2.9.0/emerging.rules.tar.gz'

  echo "Downloading ET Suricata rules..."
  # ET Rules - Suricata
  curl -Ls -o emerging.rules-suricata.tar.gz \
    'https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz'

  echo "Downloading pulledpork..."
  # PulledPork:
  curl -Ls -o "pulledpork-$(echo ${PULLEDPORK_RELEASE} | tr '/' '-').tar.gz" \
    "https://github.com/shirkdog/pulledpork/archive/${PULLEDPORK_RELEASE}.tar.gz"

  echo "Downloading ROCK Scripts..."
  # ROCK-Scripts:
  curl -Ls -o "rock-scripts-$(echo ${ROCKSCRIPTS_BRANCH} | tr '/' '-').tar.gz" \
    "https://github.com/rocknsm/rock-scripts/archive/${ROCKSCRIPTS_BRANCH}.tar.gz"

  echo "Downloading ROCK Dashboards..."
  # ROCK-Dashboards:
  curl -Ls -o "rock2-dashboards-$(echo ${ROCKDASHBOARDS_BRANCH} | tr '/' '-').tar.gz" \
    "https://github.com/rocknsm/rock-dashboards/archive/${ROCKDASHBOARDS_BRANCH}.tar.gz"

  echo "Downloading SimpleROCK Snapshot..."
  curl -Ls -o "SimpleRock-$(echo ${ROCK_BRANCH} | tr '/' '-').tar.gz" \
    "https://github.com/rocknsm/SimpleRock/archive/${ROCK_BRANCH}.tar.gz"

  # Because I'm pedantic
  popd >/dev/null
}

# Only execute if we are called directly
if [[ "${BASH_SOURCE}" == "${0}" ]]; then
  offline-snapshot $@
fi
