#!/bin/bash

usage() { echo "Usage: $0 -n NAME -k /Path/To/Public-Key [ -r /Path/To/File.rpm]" 1>&2; exit 1; }
help() { echo "Usage: $0 -n NAME -k /Path/To/Public-Key [ -r /Path/To/File.rpm]" 1>&2; exit 0; }


while getopts ":n:k:r:h:" o; do
        case "${o}" in
                n)
                        n=${OPTARG}
                        ;;
                k)
                        k=${OPTARG}
                        ;;
                r)
                        r=${OPTARG}
                        ;;
                h)
                        help
                        ;;
                *)
                        usage
                        ;;
        esac
done


function write_rpm_macro {

        sudo rpm --import $k

        echo "%_signature gpg" > ~/.rpmmacros
        echo "%_gpg_path ~/.gnupg" >> ~/.rpmmacros
        echo "%_gpg_name $n" >> ~/.rpmmacros
        echo "%_gpgbin $(which gpg)" >> ~/.rpmmacros
}


if [ -z "${n}" ] || [ -z "${k}" ]; then
        usage
fi

write_rpm_macro

if [ -n "${r}" ]; then
        rpm --addsign $r
fi
