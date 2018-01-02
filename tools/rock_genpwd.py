"""This module will generate passwords for rock users.
There are system level users and user level users that need passwords
generated. This is to help practice better security so that default
passwords are not left on each rock system.
"""
from __future__ import absolute_import, division, print_function

import argparse
import sys

import yaml

from xkcdpass import xkcd_password


def generate_password_file(yml, user_pws, system_pws):
    """Generate passwords for all accounts because file did not exist"""
    for key_name, password in system_pws.iteritems():
        yml[key_name] = generate_system_password()

    for key_name, password in user_pws.iteritems():
        yml[key_name] = generate_user_password()


def append_missing_passwords(yml, user_pws, system_pws):
    """Generate passwords only for users that are missing.
    This will skip any passwords that are already defined in the file.
    """
    for key_name, password in system_pws.items():
        try:
            if yml[key_name]:
                pass
            else:
                yml[key_name] = generate_system_password()
        except KeyError:
            yml[key_name] = generate_system_password()

    for key_name, password in user_pws.items():
        try:
            if yml[key_name]:
                pass
            else:
                yml[key_name] = generate_user_password()
        except KeyError:
            yml[key_name] = generate_user_password()


def generate_system_password():
    """Generate passwords from the xkcd library for system level accounts"""
    # generate password for a system level app

    wordfile = xkcd_password.locate_wordfile()
    mywords = xkcd_password.generate_wordlist(wordfile=wordfile)

    return xkcd_password.generate_xkcdpassword(mywords, acrostic='rock')


def generate_user_password():
    """Generate passwords from the xkcd library for user level accounts"""
    # generate password for a user level app
    wordfile = xkcd_password.locate_wordfile()
    mywords = xkcd_password.generate_wordlist(wordfile=wordfile)

    return xkcd_password.generate_xkcdpassword(mywords, acrostic='rock')


def write_password_file(yml, pw_file_path):
    """This is used to write all yml data stored in memory to disk."""
    with open(pw_file_path, 'w') as ymlfile:
        yaml.dump(yml, ymlfile, default_flow_style=False)


def get_args():
    """Get any user specified directory to write the password.yml file."""
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--directory', help='directory to write the password.yml',
                        default='/etc/rocknsm')

    args = parser.parse_args()

    return args


def run():
    """This is the main logic of the module.

    It will check to see if a password file already exists with content.
    After which it will generate in any passwords not already provided,
    and will write them to the password.yml file.
    """
    # get any passed arguments
    args = get_args()

    # set full file path
    pw_file_path = '{}/password.yml'.format(args.directory)

    # system level passwords
    system_pws = {
        'logstash_pw': '',
        'elastic_pw': '',
        'kibana_pw': ''
    }

    # user level passwords
    user_pws = {
        'kibana_admin_pw': '',
        'kibana_user_pw': ''
    }

    try:
        # parse password.yml
        with open(pw_file_path, 'r') as ymlfile:
            yml = yaml.safe_load(ymlfile)
        # if file exists and has data
        if yml:
            append_missing_passwords(yml, user_pws, system_pws)
        # file exists but is empty
        else:
            yml = {}
            generate_password_file(yml, user_pws, system_pws)

        # write the data to the file
        write_password_file(yml, pw_file_path)
    # File did not exist create it and generate passwords
    except IOError as err:
        # permission denied error
        if err.errno == 13:
            print('Permission denied!!! Please check that you have sufficient permissions to '
                  'modify and read the file /etc/rocknsm/password.yml ', file=sys.stderr)
        # file does not exist needs to be created
        if err.errno == 2:
            yml = {}
            generate_password_file(yml, user_pws, system_pws)
            try:
                write_password_file(yml, pw_file_path)
            except IOError as err_2:
                print('{errno}, Could not write changes'.format(errno=err_2), file=sys.stderr)

        else:
            print('{}'.format(err), file=sys.stderr)


if __name__ == '__main__':
    run()
