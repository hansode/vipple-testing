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

## common

function install_vipple() {
  local deploy_dir=/var/tmp/vipple

  if [[ ! -d ${deploy_dir} ]]; then
    git clone https://github.com/hansode/vipple ${deploy_dir}
  fi

  cd ${deploy_dir}
  git pull origin master
  ./install.sh
}

install_vipple
