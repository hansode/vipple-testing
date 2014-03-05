#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

# functions

## common

function run_in_target() {
  local node=${1}; shift
  vagrant ssh ${node} -c "${@}"
}

function show_ipaddr() {
  local node=${1}
  run_in_target ${node} 'ip addr show eth1 | grep -w inet'
}

## vipple

function force_stop_vipple() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple stop || :'
}

function stop_vipple() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple stop'
}

function force_start_vipple() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple start || :'
}

function start_vipple() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple start'
}

## vipple-zero

function force_stop_vipple_zero() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple-zero stop || :'
}

function stop_vipple_zero() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple-zero stop'
}

function force_start_vipple_zero() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple-zero start || :'
}

function start_vipple_zero() {
  local node=${1}
  run_in_target ${node} 'sudo service vipple-zero start'
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
