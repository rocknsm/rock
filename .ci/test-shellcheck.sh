#!/bin/bash -eu -o pipefail

# 1. Find all files, excluding .tox, .ci, .git, and *.j2 files
#    check file magic and only print shell scripts
# 2. Read in list of files and send each file to shellcheck, checking as bash
EXITCODE=0
CHECKPATH=$1

echo "Checking scripts with:"
printf "\t%s\n" "shellcheck --format gcc --shell bash --severity error filename"

find "${CHECKPATH}" \
  \( -path ./.tox -o -path ./.ci -o -path ./.git -o -name '*.j2' \) -prune -o \
  -type f  -exec sh -c 'file "$1" | grep -qE "sh(ell)? script"' _ {} \; -print |
(while IFS="" read -r file; do
    echo -n "Checking ${file}: "
    if ERRORS=$(shellcheck --format gcc --shell bash --severity error "${file}"); then
        printf "\e[32m%s\e[0m\n" "OK"
    else
        printf "\e[31mERROR\n%s\e[0m\n" "$ERRORS"
        EXITCODE=1
    fi
done

exit ${EXITCODE})
