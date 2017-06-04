+%global latest_release %(curl https://api.github.com/repos/rocknsm/rock/releases/latest)
 +%global _release %(curl https://api.github.com/repos/rocknsm/rock/releases/latest | grep tag_name | awk -F'[[:space:]]+' '{print $3}' | sed -e 's/"//g' -e 's/,//' -e 's/^v//')
 +%global _source %((curl -I $(curl https://api.github.com/repos/rocknsm/rock/releases/latest | grep tarball | awk -F'[[:space:]]+' '{print $3}' | sed -e 's/,$//' -e 's/"//g') | grep Location | awk -F'[[:space:]]+' '{print $2}' | sed -e 's/,$//' -e 's/"//g'))
 +%global _commit %(curl -I $(curl -I $(curl https://api.github.com/repos/rocknsm/rock/releases/latest | grep tarball | awk -F'[[:space:]]+' '{print $3}' | sed -e 's/,$//' -e 's/"//g') | grep Location | awk -F'[[:space:]]+' '{print $2}' | sed -e 's/,$//' -e 's/"//g') | grep ETag | awk -F'[[:space:]]+' '{print $2}' | sed -e 's/"//g')
 +%global _shortcommit %(c=%{_commit}; echo ${c:0:7})
 +%global _rockdir /opt/rocknsm/rock-%{_release}
 +
 +Name:           rocknsm
 +Version:        %{_release}
 +Release:        1%{?dist}
 +Summary:        Network Security Monitoring collections platform
 +
 +License:        BSD-3
 +URL:            http://rocknsm.io/
 +Source0:        %{source}#/%{name}-rock-v%{_release}-0-g%{_shortcommit}.tar.gz
 +
 +Requires:       ansible
 +Requires:       git
 +
 +%description
 +ROCK is a collections platform, in the spirit of Network Security Monitoring, designed by members of the Missouri National Guard's Cyber Team. It's primary focus is to provide a robust, scalable sensor platform for both enduring security monitoring and incident response missions.
 +
 +
 +%prep
 +%setup -q -n rocknsm-rock-%{_shortcommit}
 +
 +%build
 +
 +
 +%install
 +rm -rf %{buildroot}
 +DESTDIR=%{buildroot}
 +
 +#make directories
 +mkdir -p %{buildroot}/%{_rockdir}
 +mkdir -p %{buildroot}/%{_rockdir}/bin
 +mkdir -p %{buildroot}/%{_rockdir}/playbooks
 +
 +# Install ansible files
 +install -p -m 755 bin/deploy_rock.sh %{buildroot}/%{_rockdir}/bin/
 +install -p -m 755 bin/generate_defaults.sh %{buildroot}/%{_rockdir}/bin/
 +cp -a playbooks/. %{buildroot}/%{_rockdir}/playbooks
 +
 +%files
 +%defattr(0644, root, root, 0775)
 +%{_rockdir}/playbooks/*
 +
 +%doc README.md LICENSE
 +%config %{_rockdir}/playbooks/ansible.cfg
 +
 +%attr(0755, root, root) %{_rockdir}/bin/deploy_rock.sh
 +%attr(0755, root, root) %{_rockdir}/bin/generate_defaults.sh
 +
 +
 +%changelog
