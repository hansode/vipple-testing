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

start_vipple_zero node01
show_ipaddr       node01 ifname=eth1
 stop_vipple_zero node01

start_vipple_zero node02
show_ipaddr       node02 ifname=eth1
 stop_vipple_zero node02
