
# Test a random command
ansible rockserver1.lan -i inventory/dev/inventory.yml -m debug -a "msg={{ '/dev/sdb' | regex_search('(sd.)') }}"

# Get all the variables for a host
ansible rockserver1.lan -i inventory/dev/inventory.yml -m debug -a "var=hostvars"

# View ansible built in variables
ansible rockserver1.lan -i inventory/dev/inventory.yml -m setup
