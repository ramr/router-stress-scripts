#!/bin/bash

readonly NAME_PREFIX="stress"


function _delete_routes() {
    local name=$1
    echo "  - worker name: ${name} ... "
    sleep 0.0$((RANDOM%3))

    local route_prefix="${NAME_PREFIX}-${name}-id"
    local pattern="^route/${route_prefix}"

    case "$((RANDOM%3))" in
      0)                                                          ;;
      1)  oc delete route ${route_prefix}-1                       ;;
      2)  oc delete route ${route_prefix}-{1,2}                   ;;
      *)                                                          ;;
    esac

    for r in $(oc get routes -o name | grep "${pattern}"); do
      echo "cleaning up route $r ... "
      oc delete "${r}"
    done;

}  #  End of function  _delete_routes.


#
#  main():
#
ntimes=${1:-20}

for i in `seq ${ntimes}`; do
  _delete_routes "worker-${i}" &
done

_delete_routes "main" 
