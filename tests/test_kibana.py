from __future__ import absolute_import, division, print_function
from builtins import (ascii, bytes, chr, dict, filter, hex, input,
                      int, map, next, oct, open, pow, range, round,
                      str, super, zip)
import pytest
import yaml

with open('tests/vars/kibana.vars', 'r') as f:
    try:
        vars = yaml.load(f)
    except yaml.YAMLError as e:
        print(e)

# begin testing
# parametrize all of the values in the list so that we test all of them even if one fails
@pytest.mark.parametrize("package", vars.get('packages'))
# Test for packages that are installed
def test_packages_installed(host, package):
    with host.sudo():
        assert host.package(package).is_installed

@pytest.mark.parametrize("service", vars.get('services'))
# test for services that are enabled
def test_service_enabled(host, service):
    assert host.service(service).is_enabled
    assert host.service(service).is_running


# Can use this if we want to split up enabled and running into separate checks
# @pytest.mark.parametrize("service", services)
# # test for services that are running
# def test_service_running(host, service):
#     assert host.service(service).is_running


@pytest.mark.parametrize("dir_path", vars.get('dir_paths'))
# test for directories that should of been made
def test_directories(host, dir_path):
    with host.sudo():
        assert host.file(dir_path).exists
        assert host.file(dir_path).is_directory


@pytest.mark.parametrize("file_path", vars.get('file_paths'))
# test for files that should exist
def test_files(host, file_path):
    with host.sudo():
        assert host.file(file_path).exists
        assert host.file(file_path).is_file


@pytest.mark.parametrize("port", vars.get('firewall_ports'))
# test to see if port is allowed through firewalld
def test_firewall_rules(host, port):
    with host.sudo():
        out = host.check_output("firewall-cmd %s", '--list-ports')
        assert str(port) in out


# work around port testing for now, still requires netstat to be installed. Does not detect ss for some reason
@pytest.mark.parametrize("port", vars.get('listening_ports'))
# test for ports that are in a listening state
def test_network_sockets(host, port):
    scks = host.socket.get_listening_sockets()
    assert [s for s in scks if s.endswith(str(port))]


# Doesn't appear to work, but this is how we could test for specific ports listening
# @pytest.mark.parametrize("port", vars.get('listening_ports')
# def test_sockets(host, port):
#     assert host.socket("tcp://127.0.0.1:{port}".format(port=port)).is_listening