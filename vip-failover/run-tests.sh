#!/bin/bash
#
# requires:
#  bash
#

set -e
set -o pipefail

for i in ./failover-test_[0-9][0-9].sh; do
  echo === ${i} ===
  eval ${i}
done

echo "All test passed!!!"
