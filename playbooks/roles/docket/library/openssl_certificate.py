#!/usr/bin/python
##
## Copyright (c) 2017, 2018 RockNSM.
## 
## This file is part of RockNSM
## (see http://rocknsm.io).
## 
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
## 
##   http://www.apache.org/licenses/LICENSE-2.0
## 
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
## 
##
# -*- coding: utf-8 -*-

# (c) 2016, Yanis Guenane <yanis+ansible@guenane.org>
# (c) 2017, Markus Teufelberger <mteufelberger+ansible@mgit.at>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type


ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}


DOCUMENTATION = '''
---
module: openssl_certificate
author:
  - Yanis Guenane (@Spredzy)
  - Markus Teufelberger
version_added: "2.4"
short_description: Generate and/or check OpenSSL certificates
description:
    - "This module allows one to (re)generate OpenSSL certificates. It implements a notion
       of provider (ie. 'selfsigned', 'acme', 'assertonly') for your certificate.
       The 'assertonly' provider is intended for use cases where one is only interested in
       checking properties of a supplied certificate.
       Many properties that can be specified in this module are for validation of an
       existing or newly generated certificate. The proper place to specify them, if you
       want to receive a certificate with these properties is a CSR (Certificate Signing Request).
       It uses the pyOpenSSL python library to interact with OpenSSL."
requirements:
    - "python-pyOpenSSL >= 0.15"
    - acme-tiny (if using the acme provider)
options:
    state:
        default: "present"
        choices: [ present, absent ]
        description:
            - Whether the certificate should exist or not, taking action if the state is different from what is stated.
    path:
        required: true
        description:
            - Remote absolute path where the generated certificate file should be created or is already located.
    provider:
        required: true
        choices: [ 'selfsigned', 'assertonly', 'acme' ]
        description:
            - Name of the provider to use to generate/retrieve the OpenSSL certificate.
              The 'assertonly' provider will not generate files and fail if the certificate file is missing.
    force:
        default: False
        choices: [ True, False ]
        description:
            - Generate the certificate, even if it already exists.
    csr_path:
        description:
            - Path to the Certificate Signing Request (CSR) used to generate this certificate. This is not required in 'assertonly' mode.

    privatekey_path:
        description:
            - Path to the private key to use when signing the certificate.

    privatekey_passphrase:
        description:
            - The passphrase for the privatekey.

    selfsigned_digest:
        default: "sha256"
        description:
            - Digest algorithm to be used when self-signing the certificate

    selfsigned_notBefore:
        description:
            - The timestamp at which the certificate starts being valid. The timestamp is formatted as an ASN.1 TIME.
              If this value is not specified, certificate will start being valid from now.

    selfsigned_notAfter:
        description:
            - The timestamp at which the certificate stops being valid. The timestamp is formatted as an ASN.1 TIME.
              If this value is not specified, certificate will stop being valid 10 years from now.

    acme_accountkey:
        description:
            - Path to the accountkey for the 'acme' provider

    acme_challenge_path:
        description:
            - Path to the ACME challenge directory that is served on http://<HOST>:80/.well-known/acme-challenge/

    signature_algorithms:
        description:
            - list of algorithms that you would accept the certificate to be signed with
              (e.g. ['sha256WithRSAEncryption', 'sha512WithRSAEncryption']).

    issuer:
        description:
            - Key/value pairs that must be present in the issuer name field of the certificate

    subject:
        description:
            - Key/value pairs that must be present in the subject name field of the certificate

    has_expired:
        choices: [ True, False ]
        description:
            - Checks if the certificate is expired/not expired at the time the module is executed.

    version:
        description:
            - Version of the certificate. Nowadays it should almost always be 3.

    valid_at:
        description:
            - The certificate must be valid at this point in time. The timestamp is formatted as an ASN.1 TIME.

    invalid_at:
        description:
            - The certificate must be invalid at this point in time. The timestamp is formatted as an ASN.1 TIME.

    notBefore:
        description:
            - The certificate must start to become valid at this point in time. The timestamp is formatted as an ASN.1 TIME.

    notAfter:
        description:
            - The certificate must expire at this point in time. The timestamp is formatted as an ASN.1 TIME.

    valid_in:
        description:
            - The certificate must still be valid in `valid_in` seconds from now.

    keyUsage:
        description:
            - The keyUsage extension field must contain all these values.
    keyUsage_strict:
        description:
            - If set to True, The keyUsage extension field must contain only these values.

    extendedKeyUsage:
        description:
            - The extendedKeyUsage extension field must contain all these values.

    extendedKeyUsage_strict:
        description:
            - If set to True, The extendedKeyUsage extension field must contain only these values.

    subjectAltName:
        description:
            - The subjectAltName extension field must contain these values.

    subjectAltName_strict:
        description:
            - If set to True, The subjectAltName extension field must contain only these values.

notes:
    - All ASN.1 TIME values should be specified following the YYYYMMDDHHMMSSZ pattern.
      Date specified should be UTC. Minutes and seconds are mandatory.
'''


EXAMPLES = '''
- name: Generate a Self Signed OpenSSL certificate
  openssl_certificate:
    path: /etc/ssl/crt/ansible.com.crt
    privatekey_path: /etc/ssl/private/ansible.com.pem
    csr_path: /etc/ssl/csr/ansible.com.csr
    provider: selfsigned

- name: Generate a Let's Encrypt Certificate
  openssl_certificate:
    path: /etc/ssl/crt/ansible.com.crt
    csr_path: /etc/ssl/csr/ansible.com.csr
    provider: acme
    acme_accountkey: /etc/ssl/private/ansible.com.pem
    acme_challenge_path: /etc/ssl/challenges/ansible.com/

- name: Force (re-)generate a new Let's Encrypt Certificate
  openssl_certificate:
    path: /etc/ssl/crt/ansible.com.crt
    csr_path: /etc/ssl/csr/ansible.com.csr
    provider: acme
    acme_accountkey: /etc/ssl/private/ansible.com.pem
    acme_challenge_path: /etc/ssl/challenges/ansible.com/
    force: True

# Examples for some checks one could use the assertonly provider for:
- name: Verify that an existing certificate was issued by the Let's Encrypt CA and is currently still valid
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    issuer:
      O: Let's Encrypt
    has_expired: False

- name: Ensure that a certificate uses a modern signature algorithm (no SHA1, MD5 or DSA)
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    signature_algorithms:
      - sha224WithRSAEncryption
      - sha256WithRSAEncryption
      - sha384WithRSAEncryption
      - sha512WithRSAEncryption
      - sha224WithECDSAEncryption
      - sha256WithECDSAEncryption
      - sha384WithECDSAEncryption
      - sha512WithECDSAEncryption

- name: Ensure that the existing certificate belongs to the specified private key
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    privatekey_path: /etc/ssl/private/example.com.pem
    provider: assertonly

- name: Ensure that the existing certificate is still valid at the winter solstice 2017
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    valid_at: 20171221162800Z

- name: Ensure that the existing certificate is still valid 2 weeks (1209600 seconds) from now
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    valid_in: 1209600

- name: Ensure that the existing certificate is only used for digital signatures and encrypting other keys
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    keyUsage:
      - digitalSignature
      - keyEncipherment
    keyUsage_strict: True

- name: Ensure that the existing certificate can be used for client authentication
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    extendedKeyUsage:
      - clientAuth

- name: Ensure that the existing certificate can only be used for client authentication and time stamping
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    extendedKeyUsage:
      - clientAuth
      - 1.3.6.1.5.5.7.3.8
    extendedKeyUsage: strict

- name: Ensure that the existing certificate has a certain domain in its subjectAltName
  openssl_certificate:
    path: /etc/ssl/crt/example.com.crt
    provider: assertonly
    subjectAltName:
      - www.example.com
      - test.example.com
'''


RETURN = '''
filename:
    description: Path to the generated Certificate
    returned: changed or success
    type: string
    sample: /etc/ssl/crt/www.ansible.com.crt
'''


from random import randint
import datetime
import subprocess
import os

from ansible.module_utils import crypto as crypto_utils
from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native

try:
    import OpenSSL
    from OpenSSL import crypto
except ImportError:
    pyopenssl_found = False
else:
    pyopenssl_found = True


class CertificateError(crypto_utils.OpenSSLObjectError):
    pass


class Certificate(crypto_utils.OpenSSLObject):

    def __init__(self, module):
        super(Certificate, self).__init__(
            module.params['path'],
            module.params['state'],
            module.params['force'],
            module.check_mode
        )

        self.provider = module.params['provider']
        self.privatekey_path = module.params['privatekey_path']
        self.privatekey_passphrase = module.params['privatekey_passphrase']
        self.csr_path = module.params['csr_path']
        self.cert = None
        self.privatekey = None
        self.module = module

    def check(self, module, perms_required=True):
        """Ensure the resource is in its desired state."""

        state_and_perms = super(Certificate, self).check(module, perms_required)

        def _validate_privatekey():
            if self.privatekey_path:
                ctx = OpenSSL.SSL.Context(OpenSSL.SSL.TLSv1_2_METHOD)
                ctx.use_privatekey(self.privatekey)
                ctx.use_certificate(self.cert)
                try:
                    ctx.check_privatekey()
                    return True
                except OpenSSL.SSL.Error:
                    return False

        if not state_and_perms:
            return False

        self.cert = crypto_utils.load_certificate(self.path)

        if self.privatekey_path:
            self.privatekey = crypto_utils.load_privatekey(
                self.privatekey_path,
                self.privatekey_passphrase
            )
            return _validate_privatekey()

        return True


class SelfSignedCertificate(Certificate):
    """Generate the self-signed certificate."""

    def __init__(self, module):
        super(SelfSignedCertificate, self).__init__(module)
        self.serial_number = randint(1000, 99999)
        self.notBefore = module.params['selfsigned_notBefore']
        self.notAfter = module.params['selfsigned_notAfter']
        self.digest = module.params['selfsigned_digest']
        self.csr = crypto_utils.load_certificate_request(self.csr_path)
        self.privatekey = crypto_utils.load_privatekey(
            self.privatekey_path, self.privatekey_passphrase
        )
        self.cert = None

    def generate(self, module):

        if not os.path.exists(self.privatekey_path):
            raise CertificateError(
                'The private key %s does not exist' % self.privatekey_path
            )

        if not os.path.exists(self.csr_path):
            raise CertificateError(
                'The certificate signing request file %s does not exist' % self.csr_path
            )

        if not self.check(module, perms_required=False) or self.force:
            cert = crypto.X509()
            cert.set_serial_number(self.serial_number)
            if self.notBefore:
                cert.set_notBefore(self.notBefore)
            else:
                cert.gmtime_adj_notBefore(0)
            if self.notAfter:
                cert.set_notAfter(self.notAfter)
            else:
                cert.gmtime_adj_notAfter(315360000)
            cert.set_subject(self.csr.get_subject())
            cert.set_version(self.csr.get_version() - 1)
            cert.set_pubkey(self.csr.get_pubkey())

            try:
                # NOTE: This is only available starting from pyOpenSSL >= 0.15
                cert.add_extensions(self.csr.get_extensions())
            except NameError as exc:
                raise CertificateError('You need to have PyOpenSSL>= 0.15 to generate public keys')

            cert.sign(self.privatekey, self.digest)
            self.certificate = cert

            try:
                with open(self.path, 'wb') as cert_file:
                    cert_file.write(crypto.dump_certificate(crypto.FILETYPE_PEM, self.certificate))
            except EnvironmentError as exc:
                raise CertificateError(exc)

            self.changed = True

        file_args = module.load_file_common_arguments(module.params)
        if module.set_fs_attributes_if_different(file_args, False):
            self.changed = True

    def dump(self):

        result = {
            'changed': self.changed,
            'filename': self.path,
            'privatekey': self.privatekey_path,
            'csr': self.csr_path,
            'notBefore': self.notBefore,
            'notAfter': self.notAfter,
            'serial_number': self.serial_number,
        }

        return result


class AssertOnlyCertificate(Certificate):
    """validate the supplied certificate."""

    def __init__(self, module):
        super(AssertOnlyCertificate, self).__init__(module)
        self.signature_algorithms = module.params['signature_algorithms']
        self.subject = module.params['subject']
        self.issuer = module.params['issuer']
        self.has_expired = module.params['has_expired']
        self.version = module.params['version']
        self.keyUsage = module.params['keyUsage']
        self.keyUsage_strict = module.params['keyUsage_strict']
        self.extendedKeyUsage = module.params['extendedKeyUsage']
        self.extendedKeyUsage_strict = module.params['extendedKeyUsage_strict']
        self.subjectAltName = module.params['subjectAltName']
        self.subjectAltName_strict = module.params['subjectAltName_strict']
        self.notBefore = module.params['notBefore']
        self.notAfter = module.params['notAfter']
        self.valid_at = module.params['valid_at']
        self.invalid_at = module.params['invalid_at']
        self.valid_in = module.params['valid_in']
        self.message = []

    def assertonly(self):

        self.cert = crypto_utils.load_certificate(self.path)

        def _validate_signature_algorithms():
            if self.signature_algorithms:
                if self.cert.get_signature_algorithm() not in self.signature_algorithms:
                    self.message.append(
                        'Invalid signature algorithm (got %s, expected one of %s)' % (self.cert.get_signature_algorithm(), self.signature_algorithms)
                    )

        def _validate_subject():
            if self.subject:
                cert_subject = self.cert.get_subject().get_components()
                diff = [item for item in self.subject.items() if item not in cert_subject]
                if diff:
                    self.message.append(
                        'Invalid subject component (got %s, expected all of %s to be present)' % (cert_subject, self.subject.items())
                    )

        def _validate_issuer():
            if self.issuer:
                cert_issuer = self.cert.get_issuer().get_components()
                diff = [item for item in self.issuer.items() if item not in cert_issuer]
                if diff:
                    self.message.append(
                        'Invalid issuer component (got %s, expected all of %s to be present)' % (cert_issuer, self.issuer.items())
                    )

        def _validate_has_expired():
            if self.has_expired:
                if self.has_expired != self.cert.has_expired():
                    self.message.append(
                        'Certificate expiration check failed (certificate expiration is %s, expected %s)' % (self.cert.has_expired(), self.has_expired)
                    )

        def _validate_version():
            if self.version:
                # Version numbers in certs are off by one:
                # v1: 0, v2: 1, v3: 2 ...
                if self.version != self.cert.get_version() + 1:
                    self.message.append(
                        'Invalid certificate version number (got %s, expected %s)' % (self.cert.get_version() + 1, self.version)
                    )

        def _validate_keyUsage():
            if self.keyUsage:
                for extension_idx in range(0, self.cert.get_extension_count()):
                    extension = self.cert.get_extension(extension_idx)
                    if extension.get_short_name() == 'keyUsage':
                        keyUsage = [crypto_utils.keyUsageLong.get(keyUsage, keyUsage) for keyUsage in self.keyUsage]
                        if (not self.keyUsage_strict and not all(x in str(extension).split(', ') for x in keyUsage)) or \
                           (self.keyUsage_strict and not set(keyUsage) == set(str(extension).split(', '))):
                            self.message.append(
                                'Invalid keyUsage component (got %s, expected all of %s to be present)' % (str(extension).split(', '), keyUsage)
                            )

        def _validate_extendedKeyUsage():
            if self.extendedKeyUsage:
                for extension_idx in range(0, self.cert.get_extension_count()):
                    extension = self.cert.get_extension(extension_idx)
                    if extension.get_short_name() == 'extendedKeyUsage':
                        extKeyUsage = [crypto_utils.extendedKeyUsageLong.get(keyUsage, keyUsage) for keyUsage in self.extendedKeyUsage]
                        if (not self.extendedKeyUsage_strict and not all(x in str(extension).split(', ') for x in extKeyUsage)) or \
                           (self.extendedKeyUsage_strict and not set(extKeyUsage) == set(str(extension).split(', '))):
                            self.message.append(
                                'Invalid extendedKeyUsage component (got %s, expected all of %s to be present)' % (str(extension).split(', '), extKeyUsage)
                            )

        def _validate_subjectAltName():
            if self.subjectAltName:
                for extension_idx in range(0, self.cert.get_extension_count()):
                    extension = self.cert.get_extension(extension_idx)
                    if extension.get_short_name() == 'subjectAltName':
                        l_subjectAltName = [altname.replace('IP', 'IP Address') for altname in self.subjectAltName]
                        if (not self.subjectAltName_strict and not all(x in str(extension).split(', ') for x in l_subjectAltName)) or \
                           (self.subjectAltName_strict and not set(l_subjectAltName) == set(str(extension).split(', '))):
                            self.message.append(
                                'Invalid subjectAltName component (got %s, expected all of %s to be present)' % (str(extension).split(', '), l_subjectAltName)
                            )

        def _validate_notBefore():
            if self.notBefore:
                if self.cert.get_notBefore() != self.notBefore:
                    self.message.append(
                        'Invalid notBefore component (got %s, expected %s to be present)' % (self.cert.get_notBefore(), self.notBefore)
                    )

        def _validate_notAfter():
            if self.notAfter:
                if self.cert.get_notAfter() != self.notAfter:
                    self.message.append(
                        'Invalid notAfter component (got %s, expected %s to be present)' % (self.cert.get_notAfter(), self.notAfter)
                    )

        def _validate_valid_at():
            if self.valid_at:
                if not (self.valid_at >= self.cert.get_notBefore() and self.valid_at <= self.cert.get_notAfter()):
                    self.message.append(
                        'Certificate is not valid for the specified date (%s) - notBefore: %s - notAfter: %s' % (self.valid_at,
                                                                                                                 self.cert.get_notBefore(),
                                                                                                                 self.cert.get_notAfter())
                    )

        def _validate_invalid_at():
            if self.invalid_at:
                if not (self.invalid_at <= self.cert.get_notBefore() or self.invalid_at >= self.cert.get_notAfter()):
                    self.message.append(
                        'Certificate is not invalid for the specified date (%s) - notBefore: %s - notAfter: %s' % (self.invalid_at,
                                                                                                                   self.cert.get_notBefore(),
                                                                                                                   self.cert.get_notAfter())
                    )

        def _validate_valid_in():
            if self.valid_in:
                valid_in_date = datetime.datetime.utcnow() + datetime.timedelta(seconds=self.valid_in)
                valid_in_date = valid_in_date.strftime('%Y%m%d%H%M%SZ')
                if not (valid_in_date >= self.cert.get_notBefore() and valid_in_date <= self.cert.get_notAfter()):
                    self.message.append(
                        'Certificate is not valid in %s seconds from now (%s) - notBefore: %s - notAfter: %s' % (self.valid_in,
                                                                                                                 valid_in_date,
                                                                                                                 self.cert.get_notBefore(),
                                                                                                                 self.cert.get_notAfter())
                    )

        for validation in ['signature_algorithms', 'subject', 'issuer',
                           'has_expired', 'version', 'keyUsage',
                           'extendedKeyUsage', 'subjectAltName',
                           'notBefore', 'notAfter', 'valid_at',
                           'invalid_at', 'valid_in']:
            f_name = locals()['_validate_%s' % validation]
            f_name()

    def generate(self, module):
        """Don't generate anything - assertonly"""

        self.assertonly()

        if self.privatekey_path and not self.check(self.module, perms_required=False):
            self.message.append(
                'Certificate %s and private key %s does not match' % (self.path, self.privatekey_path)
            )

        if len(self.message):
            module.fail_json(msg=' | '.join(self.message))

    def check(self, module, perms_required=True):
        """Ensure the resource is in its desired state."""

        parent_check = super(AssertOnlyCertificate, self).check(module, perms_required)
        self.assertonly()
        assertonly_check = not len(self.message)
        self.message = []

        return parent_check and assertonly_check

    def dump(self):

        result = {
            'changed': self.changed,
            'filename': self.path,
            'privatekey': self.privatekey_path,
            'csr': self.csr_path,
        }

        return result


class AcmeCertificate(Certificate):
    """Retrieve a certificate using the ACME protocol."""

    def __init__(self, module):
        super(AcmeCertificate, self).__init__(module)
        self.accountkey_path = module.params['acme_accountkey_path']
        self.challenge_path = module.params['acme_challenge_path']

    def generate(self, module):

        if not os.path.exists(self.privatekey_path):
            raise CertificateError(
                'The private key %s does not exist' % self.privatekey_path
            )

        if not os.path.exists(self.csr_path):
            raise CertificateError(
                'The certificate signing request file %s does not exist' % self.csr_path
            )

        if not os.path.exists(self.accountkey_path):
            raise CertificateError(
                'The account key %s does not exist' % self.accountkey_path
            )

        if not os.path.exists(self.challenge_path):
            raise CertificateError(
                'The challenge path %s does not exist' % self.challenge_path
            )

        if not self.check(module, perms_required=False) or self.force:
            try:
                p = subprocess.Popen([
                    'acme-tiny',
                    '--account-key', self.accountkey_path,
                    '--csr', self.csr_path,
                    '--acme-dir', self.challenge_path], stdout=subprocess.PIPE)
                crt = p.communicate()[0]
                with open(self.path, 'wb') as certfile:
                    certfile.write(str(crt))
            except OSError as exc:
                raise CertificateError(exc)

        file_args = module.load_file_common_arguments(module.params)
        if module.set_fs_attributes_if_different(file_args, False):
            self.changed = True

    def dump(self):

        result = {
            'changed': self.changed,
            'filename': self.path,
            'privatekey': self.privatekey_path,
            'accountkey': self.accountkey_path,
            'csr': self.csr_path,
        }

        return result


def main():
    module = AnsibleModule(
        argument_spec=dict(
            state=dict(default='present', choices=['present', 'absent'], type='str'),
            path=dict(required=True, type='path'),
            provider=dict(choices=['selfsigned', 'assertonly', 'acme'], type='str'),
            force=dict(default=False, type='bool'),
            csr_path=dict(type='path'),

            # General properties of a certificate
            privatekey_path=dict(type='path'),
            privatekey_passphrase=dict(type='path', no_log=True),
            signature_algorithms=dict(type='list'),
            subject=dict(type='dict'),
            issuer=dict(type='dict'),
            has_expired=dict(default=False, type='bool'),
            version=dict(type='int'),
            keyUsage=dict(type='list'),
            keyUsage_strict=dict(default=False, type='bool'),
            extendedKeyUsage=dict(aliases=['extKeyUsage'], type='list'),
            extendedKeyUsage_strict=dict(aliases=['extKeyUsage_strict'], default=False, type='bool'),
            subjectAltName=dict(type='list'),
            subjectAltName_strict=dict(default=False, type='bool'),
            notBefore=dict(type='str'),
            notAfter=dict(type='str'),
            valid_at=dict(type='str'),
            invalid_at=dict(type='str'),
            valid_in=dict(type='int'),

            # provider: selfsigned
            selfsigned_digest=dict(default='sha256', type='str'),
            selfsigned_notBefore=dict(type='str'),
            selfsigned_notAfter=dict(type='str'),

            # provider: acme
            acme_accountkey_path=dict(type='path'),
            acme_challenge_path=dict(type='path'),
        ),
        supports_check_mode=True,
        add_file_common_args=True,
    )

    if not pyopenssl_found:
        module.fail_json(msg='The python pyOpenSSL library is required')

    base_dir = os.path.dirname(module.params['path'])
    if not os.path.isdir(base_dir):
        module.fail_json(
            name=base_dir,
            msg='The directory %s does not exist or the file is not a directory' % base_dir
        )

    provider = module.params['provider']

    if provider == 'selfsigned':
        certificate = SelfSignedCertificate(module)
    elif provider == 'acme':
        certificate = AcmeCertificate(module)
    else:
        certificate = AssertOnlyCertificate(module)

    if module.params['state'] == 'present':

        if module.check_mode:
            result = certificate.dump()
            result['changed'] = module.params['force'] or not certificate.check(module)
            module.exit_json(**result)

        try:
            certificate.generate(module)
        except CertificateError as exc:
            module.fail_json(msg=to_native(exc))
    else:

        if module.check_mode:
            result = certificate.dump()
            result['changed'] = os.path.exists(module.params['path'])
            module.exit_json(**result)

        try:
            certificate.remove()
        except CertificateError as exc:
            module.fail_json(msg=to_native(exc))

    result = certificate.dump()

    module.exit_json(**result)


if __name__ == "__main__":
    main()
