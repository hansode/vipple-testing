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

node=node01
#node=node02

case "${node}" in
  node01) ip4=18 opposit_ip4=19 ;;
  node02) ip4=19 opposit_ip4=18 ;;
esac

append_networking_param eth1 ip=10.126.5.${ip4} mask=255.255.255.0

##

/etc/init.d/network restart

##

case "${node}" in
  node02)
    ping -c 1 -W 3 10.126.5.${opposit_ip4}
    ;;
esac
