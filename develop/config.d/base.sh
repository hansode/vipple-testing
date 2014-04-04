#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

# Do some changes ...

ifcfg_setup=/usr/local/bin/ifcfg-setup

if [[ ! -f ${ifcfg_setup} ]]; then
  curl -fSkL https://raw.githubusercontent.com/hansode/ifcfg-setup/master/bin/ifcfg-setup -o ${ifcfg_setup}
  chmod +x ${ifcfg_setup}
fi

## functions

function install_vipple() {
  local deploy_dir=/var/tmp/vipple

  if [[ ! -d ${deploy_dir} ]]; then
    git clone https://github.com/hansode/vipple ${deploy_dir}
  fi

  cd ${deploy_dir}
  git pull origin master
  ./install.sh
}

##

install_vipple

case "$(hostname)" in
  node01) ip4=18 opposit_ip4=19 ;;
  node02) ip4=19 opposit_ip4=18 ;;
esac

ifcfg_setup=/usr/local/bin/ifcfg-setup
${ifcfg_setup} install ethernet eth1 ip=10.126.5.${ip4} mask=255.255.255.0

##

/etc/init.d/network restart

##

case "$(hostname)" in
  node02)
    ping -c 1 -W 3 10.126.5.${opposit_ip4}
    ;;
esac
