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

! start_vipple node01
