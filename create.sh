#!/bin/bash

readonly NAME_PREFIX="stress"


function _create_routes() {
    local name=$1
    echo "  - worker name: ${name} ... "
    sleep 0.0$((RANDOM%3))

    for idx in `seq $((RANDOM%10))`; do
      local route_name="${NAME_PREFIX}-${name}-id-${idx}"
      oc expose service header-test-insecure --name="${route_name}"
    done

}  #  End of function  _create_routes.


#
#  main():
#
ntimes=${1:-20}

for i in `seq ${ntimes}`; do
  _create_routes "worker-${i}" &
done

_create_routes "main" 
