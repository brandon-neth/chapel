#!/usr/bin/env bash
#
# Configure environment for arkouda testing on hpe-apollo-hdr

CHPL_TEST_ARKOUDA_TEMP_DIR=/hpelustre/chapelu/arkouda-scratch/$CHPL_NIGHTLY_TEST_CONFIG_NAME
rm -rf $CHPL_TEST_ARKOUDA_TEMP_DIR; mkdir -p $CHPL_TEST_ARKOUDA_TEMP_DIR
export CHPL_TEST_ARKOUDA_PYTEST_OPTIONS="--temp-directory=$CHPL_TEST_ARKOUDA_TEMP_DIR"
export ARKOUDA_DEFAULT_TEMP_DIRECTORY=$CHPL_TEST_ARKOUDA_TEMP_DIR
