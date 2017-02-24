#!/bin/bash

readonly NAME_PREFIX="stress"
readonly VERBOSE=""


function _check_routes() {
    local name=$1
    echo "  - worker name: ${name} ... "
    sleep 0.0$((RANDOM%3))

    local route_prefix="${NAME_PREFIX}-${name}-id"
    local curl_opts="-s -o /dev/null -w "%{http_code}""
    local worker_error=0

    for host in $(oc get routes  | grep "^${route_prefix}" | awk '{print $2}'); do
      local resolve_opts="--resolve ${host}:80:127.0.0.1"
      local status=$(curl ${curl_opts} ${resolve_opts} http://${host}/)
      if [ "${status}" == "200" ]; then
	[ -n "${VERBOSE}" ] && echo "  - Host ${host} OK, worker ${name}"
      else
	worker_error=1
	echo "ERROR: Status code from host ${host} not 200 : ${status} "
      fi
    done

    if [ ${worker_error} -eq 1 ]; then
	echo "ERROR: worker ${i} got non 200 error codes back "
    fi

}  #  End of function  _check_routes.


#
#  main():
#
ntimes=${1:-20}

for i in `seq ${ntimes}`; do
  _check_routes "worker-${i}" &
done

_check_routes "main" 
