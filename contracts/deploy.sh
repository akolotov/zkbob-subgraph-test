#!/bin/bash

# ./contracts/deploy.sh <sctipt name>
# ./contracts/deploy.sh <sctipt name> --broadcast

set -e

source ./contracts/.env

if [ "${SLOW}" == "true" ]; then
  echo "*** Every transaction will wait for the previous transaction inclusion in a block"
  forge script -vvv \
    --slow \
    --rpc-url ${RPC_HOST} \
    --private-key ${PRIVATE_KEY} \
    $@
else
  forge script -vvv \
    --rpc-url ${RPC_HOST} \
    --private-key ${PRIVATE_KEY} \
    $@
fi