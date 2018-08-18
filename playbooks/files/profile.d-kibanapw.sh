# Set passwords
function kibanapw() { if [ $# -lt 2 ]; then echo -e "Usage: kibanapw USER PASSWORD\nUsers will be added to /etc/nginx/htpasswd.users"; else egrep "^${1}:" /etc/nginx/htpasswd.users > /dev/null 2>&1; if [[ $? -eq 0 ]]; then sudo sed -i "/${1}\:/d" /etc/nginx/htpasswd.users; fi; printf "${1}:$(echo ${2} | openssl passwd -apr1 -stdin)\n" | sudo tee -a /etc/nginx/htpasswd.users > /dev/null 2>&1; fi; }

# Enable Auth
function enable_kibana_auth() { sudo sed -i 's/#auth_basic/auth_basic/g' /etc/nginx/conf.d/rock.conf; }

# Disable Auth
function disable_kibana_auth() { sudo sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/conf.d/rock.conf; }
