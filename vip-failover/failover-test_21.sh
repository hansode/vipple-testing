#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

#

. failover-functions.sh
. failover-test_setup.sh

# main

start_vipple node01
show_ipaddr  node01 ifname=eth1

! start_vipple_zero node01

start_vipple_zero node02
 stop_vipple_zero node02
start_vipple_zero node02
