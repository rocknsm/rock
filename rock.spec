%global _rockdir /opt/rocknsm/rock

Name:           rock
Version:        2.1.0
Release:        1%{?dist}
Summary:        Network Security Monitoring collections platform

License:        BSD
URL:            http://rocknsm.io/
Source0:        https://github.com/rocknsm/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       ansible >= 2.4.2
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
mkdir -p %{buildroot}/%{_rockdir}
mkdir -p %{buildroot}/%{_rockdir}/bin
mkdir -p %{buildroot}/%{_rockdir}/playbooks

# Install ansible files
install -p -m 755 bin/deploy_rock.sh %{buildroot}/%{_rockdir}/bin/
install -p -m 755 bin/generate_defaults.sh %{buildroot}/%{_rockdir}/bin/
cp -a playbooks/. %{buildroot}/%{_rockdir}/playbooks

# make dir and install tests
mkdir -p %{buildroot}/%{_rockdir}/tests
cp -a tests/. %{buildroot}/%{_rockdir}/tests

%files
%defattr(0644, root, root, 0755)
%{_rockdir}/playbooks/*
%{_rockdir}/tests/*

%doc README.md LICENSE CONTRIBUTING.md
%config %{_rockdir}/playbooks/ansible.cfg

%attr(0755, root, root) %{_rockdir}/bin/deploy_rock.sh
%attr(0755, root, root) %{_rockdir}/bin/generate_defaults.sh

%changelog
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
