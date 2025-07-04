#!/usr/bin/env bash
#
# Test default configuration on examples only, on linux64, with llvm 12

UTIL_CRON_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) ; pwd)
source $UTIL_CRON_DIR/common.bash

source /hpcdc/project/chapel/setup_llvm.bash 12

clang_version=$(clang -dumpversion)
if [ "$clang_version" != "12.0.1" ]; then
  echo "Wrong clang version"
  echo "Expected Version: 12.0.1 Actual Version: $clang_version"
  exit 2
fi

export CHPL_LAUNCHER=none

export CHPL_NIGHTLY_TEST_CONFIG_NAME="linux64-llvm12"
export CHPL_NIGHTLY_TEST_DIRS="llvm/"

$UTIL_CRON_DIR/nightly -cron -examples -blog ${nightly_args}
