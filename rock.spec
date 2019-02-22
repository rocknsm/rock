%global _rockdir /usr/share/rock
%global _sysconfdir /etc/rocknsm
%global _sbindir /usr/sbin

Name:           rock
Version:        2.3.0
Release:        1

Summary:        Network Security Monitoring collections platform

License:        BSD
URL:            http://rocknsm.io/
Source0:        https://github.com/rocknsm/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       ansible >= 2.7.0
Requires:       python-jinja2 >= 2.9.0
Requires:       python-markupsafe >= 0.23
Requires:       python-pyOpenSSL
Requires:       libselinux-python
Requires:       git

%description
ROCK is a collections platform, in the spirit of Network Security Monitoring.

%prep
%setup -q

%build


%install
rm -rf %{buildroot}
DESTDIR=%{buildroot}

#make directories
mkdir -p %{buildroot}/%{_rockdir}/roles
mkdir -p %{buildroot}/%{_rockdir}/playbooks
mkdir -p %{buildroot}/%{_sbindir}
mkdir -p %{buildroot}/%{_sysconfdir}

# Install ansible files
install -p -m 755 bin/deploy_rock.sh %{buildroot}/%{_sbindir}/
install -p -m 755 bin/generate_defaults.sh %{buildroot}/%{_sbindir}/
install -m 644 etc/hosts.ini %{buildroot}/%{_sysconfdir}/
install -m 644 etc/config.yml %{buildroot}/%{_sysconfdir}/
cp -a roles/. %{buildroot}/%{_rockdir}/roles
cp -a playbooks/. %{buildroot}/%{_rockdir}/playbooks

# make dir and install tests
mkdir -p %{buildroot}/%{_rockdir}/tests
cp -a tests/. %{buildroot}/%{_rockdir}/tests

%files
%doc README.md LICENSE CONTRIBUTING.md
%config %{_rockdir}/playbooks/group_vars/all.yml
%config %{_rockdir}/playbooks/ansible.cfg
%config %{_sysconfdir}/hosts.ini
%config %{_sysconfdir}/config.yml
%defattr(0644, root, root, 0755)
%{_rockdir}/roles/*
%{_rockdir}/playbooks/*.yml
%{_rockdir}/playbooks/templates/*
%{_rockdir}/tests/*


%attr(0755, root, root) %{_sbindir}/deploy_rock.sh
%attr(0755, root, root) %{_sbindir}/generate_defaults.sh

%changelog
* Fri Jan 25 2019 Bradford Dabbs <brad@dabbs.io> 2.3.0-1
- Update file paths to match new structure
- Bump minimum Ansible version to 2.7

* Tue Oct 30 2018 Derek Ditch <derek@rocknsm.io> 2.2.0-2
- Fixed issue with missing GPG keys (derek@rocknsm.io)
- Update logrotate configuration (derek@rocknsm.io)

* Fri Oct 26 2018 Derek Ditch <derek@rocknsm.io> 2.2.0-1
- Added support for Elastic Stack 6.4 (derek@rocknsm.io>
- Added initial support for Elastic Common Schema in Tech Preview (derek@rocknsm.io)
- Updated vars for lighttpd tests (derek@rocknsm.io)
- Removed cruft perl packages no longer needed for pulledpork.
  (derek@rocknsm.io)
- Merges in Lighttpd config and several bug fixes. (#329)
  (dcode@rocknsm.io)
- Enable/Install suricata update by default (dcode@rocknsm.io)
- Adjust 'when' for the cron job and rename local source.
  (jeff.geiger@gmail.com)
- Remove pulledpork. (jeff.geiger@gmail.com)
- Add configuration for suricata-update. (jeff.geiger@gmail.com)
- Add closing tag (bradford.dabbs@elastic.co)
- Add ISO download links (bradford.dabbs@elastic.co)
- Replace logo with latest version (bradford.dabbs@elastic.co)
- Reorganize README (bradford.dabbs@elastic.co)
- Move ECS to rock-dashboards repo (derek@rocknsm.io)

* Tue Aug 21 2018 Derek Ditch <derek@rocknsm.io> 2.1.0-2
- Move ECS to rock-dashboards repo

* Tue Aug 21 2018 Derek Ditch <derek@rocknsm.io> 2.1.0-1
- Introducing Docket, a REST API and web UI to query multiple stenographer instances
- Added Suricata-Update to manage Suricata signatures
- Added GPG signing of packages and repo metadata
- Added functional tests using [testinfra](https://testinfra.readthedocs.io/en/latest/)
- Initial support of [Elastic Common Schema](https://github.com/elastic/ecs)
- Includes full Elastic (with permission) stack including features formerly known as X-Pack
- Elastic stack is updated to 6.x
- Elastic dashboards, mappings, and Logstash config moved to module-like construct
- Suricata is updated to 4.x
- Bro is updated to 2.5.4
- Deprecated Snort
- Deprecated Pulled Pork

* Thu Jun 08 2017 spartan782 <john.hall7688@hotmail.com> 2.0.5-1
-
Tito files added.
rock.spec added.
sign_rpm.sh added.
