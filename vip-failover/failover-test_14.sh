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

force_start_vipple_zero node01
force_start_vipple_zero node01
