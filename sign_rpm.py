+#!/bin/python
 +
 +import argparse, subprocess, shlex, os
 +defaults = {}
 +defaults['rpm_dir'] = ''
 +
 +def get_args():
 +        parser = argparse.ArgumentParser(description="Setup a GPG macro to be used in signing an rpm. Optionally you can provide the location of rpm's and sign them as well")
 +        parser.add_argument('-r', '--rpm', type=str, help='Direct Path to rpm you want signed', required=False, default='')
 +        parser.add_argument('-k', '--key', type=str, help='Direct Path to gpg-key you want to use for signing', required=True)
 +        parser.add_argument('-n', '--name', type=str, help='Name used when the gpg key was generated example Johnathon Hall', required=True)
 +        #this would be needed if the user wanted to provide multiple paths instead of a wildcard for multiple rpm's to be signed.
 +        #parser.add_argument('-r', '--rpm', metavar='/Path/To/RPM', nargs='+', type=str, help='Space Sperated Path(s) to the rpm(s) you want signed', required=True)
 +        args = parser.parse_args()
 +
 +        return args.rpm, args.key, args.name
 +
 +def sign_rpm(rpm_path, key_path, key_name):
 +
 +    #import key into rpm database
 +    subprocess.call(shlex.split('sudo rpm --import '+key_path))
 +    gpg_location = subprocess.check_output(shlex.split('which gpg'))
 +
 +    #get home directory
 +    home = os.path.expanduser('~')
 +    #setup rpm macro for signing
 +    f = open(home+'/.rpmmacros', 'w')
 +    f.write('%_signature gpg\n \
 +             %_gpg_path ~/.gnupg\n \
 +             %_gpg_name '+key_name+'\n\
 +             %_gpgbin '+gpg_location+'\n')
 +
 +    print 'rpm macro for signing setup\n\nIf you want to sign an rpm during the build process from a spec file use \n\t"rpmbuild -OPTIONS --sign /path/to/spec/file"'
 +
 +    if rpm_path != '':
 +        #sign rpm
 +        subprocess.call(shlex.split('rpm --addsign '+rpm_path))
 +
 +        #check if sign worked
 +        ok = subprocess.check_output(shlex.split('rpm --checksig '+rpm_path))
 +
 +        if 'OK' in ok:
 +            print 'rpm signed successfully'
 +        else:
 +            print 'something didn\'t work. Verify your gpgkey path and make sure that it is the public key'
 +
 +
 +rpm_path, key_path, key_name = get_args()
 +sign_rpm(rpm_path, key_path, key_name)
