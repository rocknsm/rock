from __future__ import absolute_import, division, print_function
from builtins import (ascii, bytes, chr, dict, filter, hex, input,
                      int, map, next, oct, open, pow, range, round,
                      str, super, zip)
import pytest
import yaml

with open('tests/vars/bro.vars', 'r') as f:
    try:
        yml_vars = yaml.load(f)
    except yaml.YAMLError as e:
        print(e)

# begin testing
# parametrize all of the values in the list so that we test all of them even if one fails
@pytest.mark.parametrize("package", yml_vars.get('packages'))
# Test for packages that are installed
def test_packages_installed(host, package):
    with host.sudo():
        assert host.package(package).is_installed

@pytest.mark.parametrize("service", yml_vars.get('services'))
# test for services that are enabled
def test_service_enabled(host, service):
    assert host.service(service).is_enabled
    assert host.service(service).is_running


# Can use this if we want to split up enabled and running into separate checks
# @pytest.mark.parametrize("service", services)
# # test for services that are running
# def test_service_running(host, service):
#     assert host.service(service).is_running


@pytest.mark.parametrize("dir_path", yml_vars.get('dir_paths'))
# test for directories that should of been made
def test_directories(host, dir_path):
    with host.sudo():
        assert host.file(dir_path).exists
        assert host.file(dir_path).is_directory


@pytest.mark.parametrize("file_path", yml_vars.get('file_paths'))
# test for files that should exist
def test_files(host, file_path):
    file_p = file_path[0]
    try:
        file_u, file_g = file_path[1].split(':')
    except IndexError:
        file_u = None
        file_g = None
    try:
        file_m = oct(int(file_path[2], 8))
    except IndexError:
        file_m = None
    with host.sudo():
        assert host.file(file_p).exists
        assert host.file(file_p).is_file
        if file_u:
            assert host.file(file_p).user == file_u
        if file_g:
            assert host.file(file_p).group == file_g
        if file_m:
            assert oct(host.file(file_p).mode) == file_m