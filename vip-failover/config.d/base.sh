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

function install_vipple_id_conf() {
  local id=${1:-0}
  shift; eval local ${@}

  cat <<-EOS | tee /etc/vipple/vip-$(printf "%03d\n" ${id:-1}).conf
	BIND_INTERFACE="${iface}"
	VIP_ADDRESS="${ip}"
	PREFIX=${prefix:-32}
	UPSCRIPT=${upscript}
	DOWNSCRIPT=${downscript}
	EOS
}

function install_vipple_up_script() {
  local script_path=/etc/vipple/vip-up.d/date

  cat <<-'EOS' | tee ${script_path}
	#!/bin/bash
	#
	echo up
	date
	EOS

  chmod +x ${script_path}
}

function install_vipple_down_script() {
  local script_path=/etc/vipple/vip-down.d/date

  cat <<-EOS | tee ${script_path}
	#!/bin/bash
	#
	echo down
	date
	EOS

  chmod +x ${script_path}
}

##

install_vipple

case "$(hostname)" in
  node01) ip4=18 opposit_ip4=19 ;;
  node02) ip4=19 opposit_ip4=18 ;;
esac

mkdir -p /etc/vipple/vip-{up,down}.d

ifcfg_setup=/usr/local/bin/ifcfg-setup
${ifcfg_setup} install ethernet eth1 ip=10.126.5.${ip4} mask=255.255.255.0

install_vipple_id_conf 1 iface=eth1 ip=10.126.5.17 prefix=24 upscript=/etc/vipple/vip-up.d/date downscript=/etc/vipple/vip-down.d/date
install_vipple_up_script
install_vipple_down_script

##

service network restart

##

case "$(hostname)" in
  node02)
    ping -c 1 -W 3 10.126.5.${opposit_ip4}
    ;;
esac
