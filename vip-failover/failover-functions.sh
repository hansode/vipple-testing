#!/bin/bash
#
# requires:
#  bash
#

# functions

## common

function run_in_target() {
  local node=${1}; shift
  vagrant ssh ${node} -c "${@}"
}

function show_ipaddr() {
  local node=${1}
  shift; eval local "${@}"
  run_in_target ${node} "ip addr show ${ifname} | grep -w inet"
}

## vipple

function force_stop_vipple() {
  local node=${1}
  run_in_target ${node} "sudo service vipple stop || :"
}

function stop_vipple() {
  local node=${1}
  run_in_target ${node} "sudo service vipple stop"
}

function force_start_vipple() {
  local node=${1}
  run_in_target ${node} "sudo service vipple start || :"
}

function start_vipple() {
  local node=${1}
  run_in_target ${node} "sudo service vipple start"
}

## vipple-zero

function stop_vipple_zero() {
  local node=${1}
  run_in_target ${node} "sudo service vipple-zero stop"
}

function force_start_vipple_zero() {
  local node=${1}
  run_in_target ${node} "sudo service vipple-zero force-start"
}

function start_vipple_zero() {
  local node=${1}
  run_in_target ${node} "sudo service vipple-zero start"
}
