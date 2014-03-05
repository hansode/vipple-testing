#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

function append_networking_param() {
  local ifname=${1:-eth0}
  shift; eval local ${@}

  cat <<-EOS | tee -a /etc/sysconfig/network-scripts/ifcfg-${ifname}
	IPADDR=${ip}
	NETMASK=${mask}
	EOS
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

node=node01
#node=node02

case "${node}" in
  node01) ip4=18 opposit_ip4=19 ;;
  node02) ip4=19 opposit_ip4=18 ;;
esac

mkdir -p /etc/vipple/vip-{up,down}.d

append_networking_param eth1 ip=10.126.5.${ip4} mask=255.255.255.0
install_vipple_id_conf 1 iface=eth1 ip=10.126.5.17 prefix=24 upscript=/etc/vipple/vip-up.d/date downscript=/etc/vipple/vip-down.d/date
install_vipple_up_script
install_vipple_down_script

##

service network restart

##

case "${node}" in
  node02)
    ping -c 1 -W 3 10.126.5.${opposit_ip4}
    ;;
esac
