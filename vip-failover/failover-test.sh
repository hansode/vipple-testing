#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

function force_stop_vipple() {
  local node=${1}
  vagrant ssh ${node} -c 'sudo service vipple stop || :'
}

function stop_vipple() {
  local node=${1}
  vagrant ssh ${node} -c 'sudo service vipple stop'
}

function force_start_vipple() {
  local node=${1}
  vagrant ssh ${node} -c 'sudo service vipple start || :'
}

function start_vipple() {
  local node=${1}
  vagrant ssh ${node} -c 'sudo service vipple start'
}

function show_ipaddr() {
  local node=${1}
  vagrant ssh ${node} -c 'ip addr show eth1 | grep -w inet'
}

# setup

force_stop_vipple node01
force_stop_vipple node02

# main

start_vipple node01
show_ipaddr  node01
 stop_vipple node01

start_vipple node02
show_ipaddr  node02
 stop_vipple node02
