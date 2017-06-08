%global commit0 0000000000000000000000000000000000000000
%global shortcommit0 %(c=%{commit0}; echo ${c:0:7}) 

Name:           rock
Version:        2.0.9
Release:        1%{?dist}
Summary:        Network Security Monitoring collections platform

License:        BSD
URL:            http://rocknsm.io/
Source0:         https://github.com/spartan782/%{name}/archive/%{commit0}.tar.gz#/%{name}-%{shortcommit0}.tar.gz

BuildArch: noarch

%global _rockdir /opt/rocknsm/rock-%{version}

Requires:       ansible
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

%files
%defattr(0644, root, root, 0755)
%{_rockdir}/playbooks/*

%doc README.md LICENSE
%config %{_rockdir}/playbooks/ansible.cfg

%attr(0755, root, root) %{_rockdir}/bin/deploy_rock.sh
%attr(0755, root, root) %{_rockdir}/bin/generate_defaults.sh


%changelog
* Thu Jun 08 2017 spartan782 <john.hall7688@hotmail.com> 2.0.9-1
- 

* Thu Jun 08 2017 spartan782 <john.hall7688@hotmail.com> 2.0.8-1
- 
redid spec file
* Thu Jun 08 2017 spartan782 <john.hall7688@hotmail.com> 2.0.7-1
- new package built with tito
tag 2.0.6
* Thu Jun 08 2017 spartan782 <john.hall7688@hotmail.com> 2.0.6-1
- new package built with tito

