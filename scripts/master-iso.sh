#!/bin/bash

NAME="ROCK"
VERSION="2.0"
RELEASE="1"
ARCH="x86_64"
KICKSTART="ks.cfg"
TIMESTAMP=$(date +%y%m%d_%H%M%S)
SCRIPT_DIR=$(dirname $(readlink -f $0))

. ./offline-snapshot.sh

function cleanup() {
  umount $TMP_ISO
  [ -d ${TMP_ISO} ] && rm -rf ${TMP_ISO}
  [ -d ${TMP_NEW} ] && rm -rf ${TMP_NEW}
  [ -d ${TMP_RPMDB} ] && rm -rf ${TMP_RPMDB}
}

TMP_ISO=$(mktemp -d)
TMP_NEW=$(mktemp -d)
TMP_RPMDB=$(mktemp -d)

trap cleanup EXIT

function check_depends() {

  which mkisofs    # genisoimage
  which flattenks  # pykiskstart
  which createrepo # createrepo
}

function usage() {
  echo "Usage: $0 CentOS-7-x86_64-Everything-1511.iso [output.iso]"
  exit 2
}

function mkiso() {
  local _build_dir=$1
  local _iso_fname=$2

  /usr/bin/mkisofs -quiet -U -A "${NAME} ${VERSION} ${ARCH}" \
    -V  "${NAME} ${VERSION} ${ARCH}" -volset  "${NAME} ${VERSION} ${ARCH}" \
    -untranslated-filenames -J -joliet-long -r -v -T \
    -x ./lost+found -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e images/efiboot.img -no-emul-boot \
    -o ${_iso_fname} ${_build_dir}
}

function main() {

  # Check preconditions
  if [ $# -lt 1 ] || [ -z "$1" ]; then usage; fi
  if [ $(id -u) != 0 ]; then echo "Run this script as root (try sudo)"; exit 1; fi

  # Download offline-snapshot
  offline-snapshot

  # Generate output filename
  TIMESTAMP=$(date +%y%m%d_%H%M%S)
  OUT_ISO=${1/.iso/-$TIMESTAMP}.iso
  [ $# -eq 2 ] && [ ! -z "$2" ] && OUT_ISO=$2

  # Mount existing iso and copy to new dir
  mount -o loop -t iso9660 "$1" ${TMP_ISO}
  rsync -a --exclude=Packages --exclude=repodata ${TMP_ISO}/ ${TMP_NEW}/

  # Remove TRANS files
  find ${TMP_NEW} -name TRANS.TBL -delete

  # Add new isolinux & grub config
  read -r -d '' template_json <<EOF || echo
  {
    "name": "${NAME}",
    "version": "${VERSION}",
    "arch": "${ARCH}",
    "kickstart": "${KICKSTART}",
    "build": "${TIMESTAMP}"
  }
EOF

  echo ${template_json} | \
    py 'jinja2.Template(open("isolinux.cfg.j2").read()).render(json.loads(sys.stdin.read()))' | \
    cat - > ${TMP_NEW}/isolinux/isolinux.cfg

  echo ${template_json} | \
    py 'jinja2.Template(open("grub.cfg.j2").read()).render(json.loads(sys.stdin.read()))' | \
    cat - > ${TMP_NEW}/EFI/BOOT/grub.cfg
#
#   # Add repo file for rocksnm repo content
#   cat << 'EOF' | tee /etc/yum.repos.d/rock-devel.repo
# [rocknsm_dev]
# name=rocknsm_dev
# baseurl=https://packagecloud.io/rocknsm/dev/el/7/$basearch
# repo_gpgcheck=1
# enabled=1
# gpgkey=https://packagecloud.io/rocknsm/dev/gpgkey
# sslverify=1
# sslcacert=/etc/pki/tls/certs/ca-bundle.crt
# metadata_expire=300
# EOF
#
#   # Update metadata cache
#   yum makecache fast
#
#   # Download minimal set of packages for kickstart
#   grep -vE '^[%#-]|^$' ks/packages.list | \
#     awk '{print$1}' | \
#     xargs sudo yum install --downloadonly --releasever=/ \
#       --downloaddir=${TMP_NEW}/Packages/ \
#       --installroot=${TMP_RPMDB}
#
#   # Download rock packages for later install
#   grep -vE '^[%#-]|^$' ks/rock_packages.list | \
#     awk '{print$1}' | \
#     xargs sudo yum install --downloadonly --releasever=/ \
#       --downloaddir=${TMP_NEW}/Packages/ \
#       --installroot=${TMP_RPMDB}
#
#   # Add packages needed for anaconda
#   grep -vE '^[%#-]|^$' ks/installer_packages.list | \
#     awk '{print$1}' | \
#     xargs sudo yum install --downloadonly --releasever=/ \
#       --downloaddir=${TMP_NEW}/Packages/ \
#       --installroot=${TMP_RPMDB}

  rsync --recursive --quiet ${ROCK_CACHE_DIR}/ ${TMP_NEW}/

  # Clear old repo data & generate fresh
  rm -rf ${TMP_NEW}/repodata
  mkdir -p ${TMP_NEW}/repodata
  cp $(ls ${TMP_ISO}/repodata/*-comps.xml | head -1) ${TMP_NEW}/repodata/comps.xml
  createrepo -g ${TMP_NEW}/repodata/comps.xml ${TMP_NEW}

  # Generate flattened kickstart & add pre-inst hooks
  ksflatten -c ks/install.ks -o "${TMP_NEW}/${KICKSTART}"

  # Spin the iso
  mkiso "${TMP_NEW}" "$OUT_ISO"

}

main $@
