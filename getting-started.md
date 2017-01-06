# ROCK NSM Beta 1 Notes

Table of Contents

* [Intro](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#intro)
* [Ch-cha-cha-changes](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#ch-cha-cha-changes)
* [Installation](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#installation)
  * [Using the ISO](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#using-the-iso)
  * [Install from the repo](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#install-from-the-repo)
  * [Configuration](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#configuration)
* [Known Issues](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#known-issues)

## Intro {#user-content-intro}

In an effort to get this into hands of people that will break it and or make it useful, I’m sharing this ISO and some notes about how to use it. Note this is a work in progress, and I will build upon these notes to make what will ultimately be the release notes.

Last caveat, there’s nothing secret here. Everything on the ISO is available in a repo, including the build scripts. I’m not going to go into how to build this, but a curious little rhino could likely figure it out without too much trouble poking around the source tree.

## Ch-cha-cha-changes {#user-content-ch-cha-cha-changes}

> Time to face the change…​

Some of the biggest changes with ROCK 2.0 are upgrading all the software to the latest versions. Here’s a list.

| Software | Version | Notes |
| :--- | :--- | :--- |
| CentOS | 7.3 \(1611\) |  |
| Bro | 2.5 | Including plugins for kafka log output and af\_packet capture |
| Suricata | 3.1.3 | _This is the default signature-based IDS_ |
| Snort | 2.9.8.3 | _This is now an optional replacement for suricata_ |
| Stenographer | Git 12106b |  |
| Kafka | 0.10.0.0 |  |
| Elasticsearch | 5.1.1 |  |
| Logstash | 5.1.1 |  |
| Kibana | 5.1.1 |  |
| Ansible | 2.2.0.0 |  |

On top of software updates, we also changed the deployment mechanism to using Ansible as the primary mechanism. We did this for a few reasons: I used it for one of my full-time projects, it’s super lightweight and available in EPEL, doesn’t require an agent, super easy to understand. I’m hoping that ultimately this makes the platform more approachable to a wider community and better suitable to offline or isolated install environments, which I’ve frequently encountered for sensor networks. That said, the chef cookbooks are not going away and may eventually be updated in parallel, but understand that they lag behind.

On that last note, we now have an ISO that \_should \_contain everything you need to deploy. The ISO is merely a snapshot of packages available at the time and latest snapshot of various Git repositories.

## Installation {#user-content-installation}

### Using the ISO {#user-content-using-the-iso}

Download the ISO here:

| Filename | TODO |
| :--- | :--- |
| File Size | TODO |
|  | TODO |

I’ve tested the ISO booting mostly in a VMware VM, using both BIOS and EFI boots. I’ve also burned it to a USB thumbdrive \(I used the 16 GB USB3 from MicroCenter\) and installed it in BIOS mode on my home test sensor. For now, you’ll have to Google how to copy an ISO to a thumbdrive. I used`dd`on a Mac.

Boot the ISO. If you’re installing in a VM, I recommend you disable the "consistent naming" of network interfaces, since it makes no sense in the VMware \(or other hypervisor\) universe. When the boot splash screen appears, pressTab, and it will allow you to edit. Add the following:

```
biosdevname=0 if.netnames=0
```

This will ensure you get interface names like`eth0`. If you have physical hardware, I\_highly\_recommend that you do not use this function.

The installer is just Anaconda \(the default RHEL/CentOS installer\) with a kickstart preseed which sets some values. You will be presented with a graphical installer that will automatically start installing. During the installation stage, you will be given the opportunity to add a user. The `root` account will be locked, so add a user with "administrator" privileges. For the sake of documentation, I will call this user `rockadmin`. Marking the user with admin access will give you access to sudo.

You’re now ready for [Configuration](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#configuration)

### Install from the repo {#user-content-install-from-the-repo}

You can also clone the ROCK repository. The instructions for the ISO above use a snapshot of the`devel`repo. You can clone this repo and simply run the`./generate_defaults.sh`script in the`ansible`directory. This will generate the file`/etc/rocknsm/config.yml`.

You’re now ready for[Configuration](https://gist.github.com/dcode/a9f53f201b85398af1e67a4f7d9fa52a#configuration)

### Configuration {#user-content-configuration}

If you wish to run an offline install \(the ISO sets you up for this already\) edit`/etc/rocknsm/config.yml`and change the following setting as shown:

```
rock_online_install: False
```

If this value is set to`True`, Ansible will configure your system for the yum repositories listed and pull packages and git repos directly from the URLs given. You could easily point this to local mirrors, if needed.

While you’re in there, you can change the auto-detected defaults, such as which interfaces to use, hostname, fqdn, resources to use, etc. You can also disable features altogether at the bottom by simply changing the feature value to`False`as shown below. Don’t do this unless you know what you’re doing.

```
with_nginx: False 
(1)
```

1. This disables nginx from installing or being configured. Note that it will not remove it if it is already present.

Once you’ve completed flipping the bits as you see fit, simply run`/opt/rocknsm/ansible/deploy_rock.sh`. If everything is well, this should install all the components and give you a success banner.

## Known Issues {#user-content-known-issues}

There’s some listed on GitHub.

1. The aforementioned auto-generation of passwords

2. No dashboards in Kibana yet

3. The`/etc/issue`isn’t updated quite right

4. ???

5. What have you found?



