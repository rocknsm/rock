from __future__ import absolute_import, division, print_function
from builtins import (ascii, bytes, chr, dict, filter, hex, input,
                      int, map, next, oct, open, pow, range, round,
                      str, super, zip)
from xkcdpass import xkcd_password

import yaml
import argparse


def generate_password_file(yml, user_pws, system_pws):
    for key_name, password in system_pws.iteritems():
        yml[key_name] = generate_system_password()

    for key_name, password in user_pws.iteritems():
        yml[key_name] = generate_user_password()


def append_missing_passwords(yml, user_pws, system_pws):
    for key_name, password in system_pws.iteritems():
        try:
            if yml[key_name]:
                pass
            else:
                yml[key_name] = generate_system_password()
        except KeyError:
            yml[key_name] = generate_system_password()


    for key_name, password in user_pws.iteritems():
        try:
            if yml[key_name]:
                pass
            else:
                yml[key_name] = generate_user_password()
        except KeyError:
           yml[key_name] = generate_user_password()


def generate_system_password():
    # generate password for a system level app

    wordfile = xkcd_password.locate_wordfile()
    mywords = xkcd_password.generate_wordlist(wordfile=wordfile)

    return xkcd_password.generate_xkcdpassword(mywords, acrostic='rock')


def generate_user_password():
    # generate password for a user level app
    wordfile = xkcd_password.locate_wordfile()
    mywords = xkcd_password.generate_wordlist(wordfile=wordfile)

    return xkcd_password.generate_xkcdpassword(mywords, acrostic='rock')


def write_password_file(yml, pw_file_path):
    with open(pw_file_path, 'w') as ymlfile:
        yaml.dump(yml, ymlfile, default_flow_style=False)


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--directory', help='directory to write the password.yml',
                        default='/etc/rocknsm')

    args = parser.parse_args()

    return args


def run():
    # get any passed arguments
    args = get_args()

    # set full file path
    pw_file_path = '{}/password.yml'.format(args.directory)

    # system level passwords
    system_pws = { 'logstash_pw': '',
                   'elastic_pw': '',
                   'kibana_pw': ''}

    # user level passwords
    user_pws = {'kibana_admin_pw': '',
                'kibana_user_pw': ''}

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
            print('Permission denied!!! Please check that you have sufficient permissions to modify and read the file '
                  '/etc/rocknsm/password.yml ')
        # file does not exist needs to be created
        if err.errno == 2:
            yml = {}
            generate_password_file(yml, user_pws, system_pws)
            try:
                write_password_file(yml, pw_file_path)
            except IOError as err_2:
                print('{errno}, Could not write changes'.format(errno=err_2))

        else:
            print('{}'.format(err))


if __name__ == '__main__':
    run()
