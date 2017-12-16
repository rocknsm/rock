
## Ansible Styleguide

The styleguide that follows was adopted from [whitecloud/ansible-styleguide](https://github.com/whitecloud/ansible-styleguide/blob/master/README.md). We'll adapt this as we go, and hopefully get some configurations for tools like `yamllint` that can do some automated checks against it.

### Why?

It's important to follow a consistent style so that it's easier to collaborate on the project and troubleshoot errors. This guide seemed like a pretty good start. Automated checks will be able to let us use continuous integration testing (like TravisCI) to validate pull requests and such.

*TODO*: The code in here does not currently meet all of these styles. That is a task to be done.

## Table of Contents
  
  1. [Practices](#practices)
  1. [Start of Files](#start-of-files)
  1. [End of Files](#end-of-files)
  1. [Quotes](#quotes)
  1. [Environment](#environment)
  1. [Booleans](#booleans)
  1. [Key value pairs](#key-value-pairs)
  1. [Sudo](#sudo)
  1. [Hosts Declaration](#hosts-declaration)
  1. [Task Declaration](#task-declaration)
  1. [Include Declaration](#include-declaration)
  1. [Role Declaration](#role-declaration)
  1. [Spacing](#spacing)

## Practices

You should follow the [Best Practices](http://docs.ansible.com/ansible/playbooks_best_practices.html) defined by the Ansible documentation when developing playbooks.

### Why?

The Ansible developers have a good understanding of how the playbooks work and where they look for certain files. Following these practices will avoid a lot of problems.

### Why Doesn't Your Style Follow Theirs?

The script examples are inconsistent in style throughout the Ansible documentation; the purpose of this document is to define a consistent style that can be used throughout Ansible scripts to create robust, readable code.

## Start of Files

You should start your scripts with some comments explaining what the script's purpose does (and an example usage, if necessary), followed by `---` with blank lines around it;, then followed by the rest of the script.

```yaml
#bad
- name: 'Change s1m0n3's status'
  service:
    enabled: true
    name: 's1m0ne'
    state: '{{ state }}'
  become: true
  
#good
# Example usage: ansible-playbook -e state=started playbook.yml
# This playbook changes the state of s1m0n3 the robot

---

- name: 'Change s1m0n3's status'
  service:
    enabled: true
    name: 's1m0ne'
    state: '{{ state }}'
  become: true
```

### Why?

This makes it easier to quickly find out the purpose/usage of a script, either by opening the file or using the `head` command.

## End of Files

You should always end your files with a newline.

### Why?

This is common Unix best practice, and avoids any prompt misalignment when printing files in a terminal.

## Quotes

**We always quote strings** and prefer single quotes over double quotes. The only time you should use double quotes is when they are nested within single quotes (e.g. Jinja map reference), or when your string requires escaping characters (e.g. using "\n" to represent a newline). If you must write a long string, we use the "folded scalar" style and omit all special quoting. The only things you should avoid quoting are booleans (e.g. true/false), numbers (e.g. 42), and things referencing the local Ansible environemnt (e.g. boolean logic or names of variables we are assigning values to).

```yaml
# bad
- name: start robot named S1m0ne
  service:
    name: s1m0ne
    state: started
    enabled: true
  become: true

# good
- name: 'start robot named S1m0ne'
  service:
    name: 's1m0ne'
    state: 'started'
    enabled: true
  become: true

# double quotes w/ nested single quotes
- name: 'start all robots'
  service:
    name: '{{ item["robot_name"] }}''
    state: 'started'
    enabled: true
  with_items: '{{ robots }}'
  become: true

# double quotes to escape characters
- name 'print some text on two lines'
  debug:
    msg: "This text is on\ntwo lines"

# folded scalar style
- name: 'robot infos'
  debug:
    msg: >
      Robot {{ item['robot_name'] }} is {{ item['status'] }} and in {{ item['az'] }}
      availability zone with a {{ item['curiosity_quotient'] }} curiosity quotient.
  with_items: robots

# folded scalar when the string has nested quotes already
- name: 'print some text'
  debug:
    msg: >
      “I haven’t the slightest idea,” said the Hatter.

# don't quote booleans/numbers
- name: 'download google homepage'
  get_url:
    dest: '/tmp'
    timeout: 60
    url: 'https://google.com'
    validate_certs: true

# variables example 1
- name: 'set a variable'
  set_fact:
    my_var: 'test'

# variables example 2
- name: 'print my_var'
  debug:
    var: my_var
  when: ansible_os_family == 'Darwin'

# variables example 3
- name: 'set another variable'
  set_fact:
    my_second_var: '{{ my_var }}'
```
### Why?

Even though strings are the default type for YAML, syntax highlighting looks better when explicitly set types. This also helps troubleshoot malformed strings when they should be properly escaped to have the desired effect.

## Environment 

When provisioning a server with environment variables add the environment variables to `/etc/environment` with lineinfile. Do this from the ansible role that is associated with the service or application that is being installed. For example for Tomcat installation the `CATALINA_HOME` environment variable is often used to reference the folder that contains Tomcat and its associated webapps. 

```yaml
- name: 'add line CATALINA_HOME to /etc/environment'
  lineinfile:
    dest: '/etc/environment'
    line: 'CATALINA_HOME={{ tomcat_home }}'
    state: 'present'
  become: true
```

### Why?
Environment definition files are typically shared so blowing them away by templating them can cause problems. Having the specific environment variable included by `lineinfile` makes it easier to track which applications are dependent upon the environment variable.

## Booleans

```yaml
# bad
- name: 'start sensu-client'
  service:
    name: 'sensu-client'
    state: 'restarted'
    enabled: 1
  become: 'yes'
 
# good
- name: 'start sensu-client'
  service:
    name: 'sensu-client'
    state: 'restarted'
    enabled: true
  become: true
```

### Why?
There are many different ways to specify a boolean value in ansible, `True/False`, `true/false`, `yes/no`, `1/0`. While it is cute to see all those options we prefer to stick to one : `true/false`. The main reasoning behind this is that Java and JavaScript have similar designations for boolean values. 

## Key value pairs

Use only one space after the colon when designating a key value pair

```yaml
# bad
- name : 'start sensu-client'
  service:
    name    : 'sensu-client'
    state   : 'restarted'
    enabled : true
  become : true


# good
- name: 'start sensu-client'
  service:
    name: 'sensu-client'
    state: 'restarted'
    enabled: true
  become: true
```

**Always use the map syntax,** regardless of how many pairs exist in the map.

```yaml
# bad
- name: 'create checks directory to make it easier to look at checks vs handlers'
  file: 'path=/etc/sensu/conf.d/checks state=directory mode=0755 owner=sensu group=sensu'
  become: true
  
- name: 'copy check-memory.json to /etc/sensu/conf.d'
  copy: 'dest=/etc/sensu/conf.d/checks/ src=checks/check-memory.json'
  become: true
  
# good
- name: 'create checks directory to make it easier to look at checks vs handlers'
  file:
    group: 'sensu'
    mode: '0755'
    owner: 'sensu'
    path: '/etc/sensu/conf.d/checks'
    state: 'directory'
  become: true
  
- name: 'copy check-memory.json to /etc/sensu/conf.d'
  copy:
    dest: '/etc/sensu/conf.d/checks/'
    src: 'checks/check-memory.json'
  become: true
```

### Why?

It's easier to read and it's not hard to do. It reduces changeset collisions for version control.

## Sudo
Use the new `become` syntax when designating that a task needs to be run with `sudo` privileges

```yaml
#bad
- name: 'template client.json to /etc/sensu/conf.d/'
  template:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'
  sudo: true
 
# good
- name: 'template client.json to /etc/sensu/conf.d/'
  template:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'
  become: true
```
### Why?
Using `sudo` was deprecated at [Ansible version 1.9.1](http://docs.ansible.com/ansible/become.html)

## Hosts Declaration

`host` sections should follow this general order:

```yaml
# host declaration
# host options in alphabetical order
# pre_tasks
# roles
# tasks

# example
- hosts: 'webservers'
  remote_user: 'centos'
  vars:
    tomcat_state: 'started'
  pre_tasks:
    - name: 'set the timezone to America/Boise'
      lineinfile:
        dest: '/etc/environment'
        line: 'TZ=America/Boise'
        state: 'present'
      become: true
  roles:
    - { role: 'tomcat', tags: 'tomcat' }
  tasks:
    - name: 'start the tomcat service'
      service:
        name: 'tomcat'
        state: '{{ tomcat_state }}'
```

### Why?

A proper definition for how to order these maps produces consistent and easily readable code.

## Task Declaration

A task should be defined in such a way that it follows this general order:

```yaml
# task name
# tags
# task map declaration (e.g. service:)
# task parameters in alphabetical order (remember to always use multi-line map syntax)
# loop operators (e.g. with_items)
# task options in alphabetical order (e.g. become, ignore_errors, register)

# example
- name: 'create some ec2 instances'
  tags: 'ec2'
  ec2:
    assign_public_ip: true
    image: 'ami-c7d092f7'
    instance_tags:
      Name: '{{ item }}'
    key_name: 'my_key'
  with_items: '{{ instance_names }}'
  ignore_errors: true
  register: ec2_output
  when: ansible_os_family == 'Darwin'
```

### Why?

Similar to the hosts definition, having a well-defined style here helps us create consistent code.

## Include Declaration

For `include` statements, make sure to quote filenames and only use blank lines between `include` statements if they are multi-line (e.g. they have tags).

```yaml
# bad
- include: other_file.yml

- include: 'second_file.yml'

- include: third_file.yml tags=third

# good

- include: 'other_file.yml'
- include: 'second_file.yml'

- include: 'third_file.yml'
  tags: 'third'
```

### Why?

This tends to be the most readable way to have `include` statements in your code.

## Role Declaration

When defining a role, the `tasks/main.yml` file should only contain something like the following:

```yaml
---

- include: 'role.yml'
```

Where `role.yml` has the same name as the role and contains all of the tasks involved in the role itself.

### Why?

When working in multi-file projects, having several `main.yml` files open at once can get very confusing. However, if every role file is named after itself, it's much easier to work with several files.

## Spacing

You should have blank lines between two host blocks, between two task blocks, and between host and include blocks. When indenting, you should use 2 spaces to represent sub-maps, and multi-line maps should start with a `-`). For a more in-depth example of how spacing (and other things) should look, consult [style.yml](style.yml).

### Why?

This produces nice looking code that is easy to read.

## Variable Names

Use `snake_case` for variable names in your scripts. All variables should prefix with the name of the scope that it exists. For project-wide scope, use `rocknsm_`. For application or role-specific variables, use that component's name as the prefix.

```yaml
# bad
- name: 'set some facts'
  set_fact:
    Boolean: true
    broint: 20
    string: 'test'

# good
- name: 'set some facts'
  set_fact:
    rocknsm_boolean: true
    bro_int: 20
    kafka_string: 'test'
```

### Why?

Ansible uses `snake_case` for module names so it makes sense to extend this convention to variable names. Prefixing the variable names with the identifier of the scope prevents accidental overrides of variables and makes it very clear in a `host_vars` or `group_vars` file exactly what that variable is used for.
