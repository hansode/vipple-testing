#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

#node=node01
node=node02

case "${node}" in
  node01) ip4=18 opposit_ip4=19 ;;
  node02) ip4=19 opposit_ip4=18 ;;
esac

ifcfg_setup=/usr/local/bin/ifcfg-setup
${ifcfg_setup} install ethernet eth1 ip=10.126.5.${ip4} mask=255.255.255.0

##

/etc/init.d/network restart

##

case "${node}" in
  node02)
    ping -c 1 -W 3 10.126.5.${opposit_ip4}
    ;;
esac
