#!/bin/bash -eux

yum -y install epel-release

yum -y install python-pip python-jinja2 python-simplejson genisoimage pykickstart createrepo rsync isomd5sum syslinux

pip install pythonpy
