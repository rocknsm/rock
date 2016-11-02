# Build ISO scripts

## Prereqs

Install tool dependencies by running:

```
sudo ./bootstrap
```

This will install the needed RPMs, pkg repos, and Python modules.

## Building the ISO

You need to have a working CentOS 7 ISO, I think any will do. Currently,
the script doesn't do any smart caching, simply downloads all needed RPMs
using yum. If you're tight on bandwidth, you might setup a caching proxy
server. I've had good experience with `polipo`.

Run the `master_iso.sh` script, as root and give it the path to your
source ISO, then optionally the the output filename.

Example:
```
sudo ./master_iso.sh /vagrant/CentOS-7-x86_64-Everything-1511.iso rocknsm-20161101.iso
```

## Support dir

In the top level of this git repo is an empty dir, `repo/support`. Anything
in this directory will be copied to `/support/` on the ISO. This is useful
for including additional scripts or support files to use during the `%post`
install script, or to install on the host.
