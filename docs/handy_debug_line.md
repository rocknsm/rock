ansible rockserver1.lan -i inventory/dev/inventory.yml -m debug -a "msg={{ '/dev/sdb' | regex_search('(sd.)') }}"
