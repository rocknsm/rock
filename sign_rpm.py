#!/bin/python

import argparse, subprocess, shlex, os, sys
defaults = {}
defaults['rpm_dir'] = ''

def get_args():
        parser = argparse.ArgumentParser(description="Setup a GPG macro to be used in signing an rpm. Optionally you can provide the location of rpm's and sign them as well")
        parser.add_argument('-r', '--rpm', type=str, help='Direct Path to rpm you want signed', required=False, default='')
        parser.add_argument('-k', '--key', type=str, help='Direct Path to gpg-key you want to use for signing', required=True)
        parser.add_argument('-n', '--name', type=str, help='Name used when the gpg key was generated example Johnathon Hall', required=True)
        parser.add_argument('-b', '--build', type=str, help='Direct Path to spec file to build rpm utilizing rpmbuild and mock', require=False)
        parser.add_argument('-d', '--rpmbuild_define', metavar='"_topdir /TMP/rpmbuild" "_version 1.0"', nargs='+' help='Quoted space seperated rpmbuild --define options you want to use', required=False, default='')
        parser.add_argument('-m', '--mock_chroot', type=str, help='specified chroot configuration to use during mock build phase')
        #this would be needed if the user wanted to provide multiple paths instead of a wildcard for multiple rpm's to be signed.
        #parser.add_argument('-r', '--rpm', metavar='/Path/To/RPM', nargs='+', type=str, help='Space Sperated Path(s) to the rpm(s) you want signed', required=True)
        args = parser.parse_args()

        return args.rpm, args.key, args.name, args.build, args.rpmbuild_define, args.mock_chroot

def sign_rpm(rpm_path, key_path, key_name, spec_dir, define_options, mock_chroot):

    #import key into rpm database
    subprocess.call(shlex.split('sudo rpm --import '+key_path))
    gpg_location = subprocess.check_output(shlex.split('which gpg'))

    if gpg_location == '':
        print 'gpg binary not found'
        sys.exit(0)
    
    #get home directory
    home = os.path.expanduser('~')
    #setup rpm macro for signing
    f = open(home+'/.rpmmacros', 'w')
    f.write('%_signature gpg\n \
             %_gpg_path ~/.gnupg\n \
             %_gpg_name '+key_name+'\n\
             %_gpgbin '+gpg_location+'\n')

    print 'rpm macro for signing setup\n\nIf you want to sign an rpm during the build process from a spec file use \n\t"rpmbuild -OPTIONS --sign /path/to/spec/file"'

    if rpm_path != '':
        #sign rpm
        subprocess.call(shlex.split('rpm --addsign '+rpm_path))

        #check if sign worked
        ok = subprocess.check_output(shlex.split('rpm --checksig '+rpm_path))

        if 'OK' in ok:
            print 'rpm signed successfully'
        else:
            print 'something didn\'t work. Verify your gpgkey path and make sure that it is the public key'

    if spec_dir != ''
        try:
            #get all the define options for rpmbuild command
            define_options_str = ''
            for option in define_options:
                define_options_str = define_options_str+'--define '+option+' '

            #create SRPM    
            subprocess.call(shlex.split('rpmbuild --sign -bs '+spec_dir+' '+temp))

            #create RPM
            mock_cmd = 'sudo mock '
            if mock_chroot != '':
                mock_cmd = mock_cmd +'-r '+mock_chroot+' '
            mock_cmd = mock_cmd+' rebuild '+spec_dir
                
            subprocess.call(shlex.split(mock_cmd))

rpm_path, key_path, key_name, spec_dir, define_options, mock_chroot = get_args()
sign_rpm(rpm_path, key_path, key_name, spec_dir, define_options, mock_chroot)
