from __future__ import absolute_import, division, print_function
from builtins import (ascii, bytes, chr, dict, filter, hex, input,
                      int, map, next, oct, open, pow, range, round,
                      str, super, zip)
import pytest
import yaml

with open('tests/vars/common.vars', 'r') as f:
    try:
        yml_vars = yaml.load(f)
    except yaml.YAMLError as e:
        print(e)


# begin testing
# parametrize all of the values in the list so that we test all of them even if one fails
def test_passwordless_sudo(host):
    assert host.sudo()

@pytest.mark.parametrize("package", yml_vars.get('packages'))
# Test for packages that are installed
def test_packages_installed(host, package):
    with host.sudo():
        assert host.package(package).is_installed


def test_ipv6_disabled(host):
    assert host.file('/etc/sysctl.d/10-ROCK.conf').contains('net.ipv6.conf.all.disable_ipv6=1')
    assert host.file('/etc/sysctl.d/10-ROCK.conf').contains('net.ipv6.conf.default.disable_ipv6=1')


def test_ipv6_loopback_disabled(host):
    assert not host.file('/etc/hosts').contains('::1')
