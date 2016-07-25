#!/bin/bash

readonly OPENHPC_HTTP_URL="http://build.openhpc.community/"
readonly OPENHPC_HTTPS_URL="https://build.openhpc.community/"
readonly SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

check_user() {
	if [ "${UID}" -ne "0" ]; then
		echo "Error: Run this script as root" >&2
		exit 1
	fi
}

check_proxy() {
	echo "Checking HTTP connections to the outside world"
	curl --connect-timeout 3 -s "${OPENHPC_HTTP_URL}" > /dev/null
	if [ "$?" -ne "0" ]; then
		echo "Error: HTTP connection to ${OPENHPC_HTTP_URL} failed." >&2
		echo "If you are behind proxy, make sure to export http_proxy and https_proxy variables" >&2
		exit 1
	fi
	echo "Checking HTTPS connections to the outside world"
	curl --connect-timeout 3 -s "${OPENHPC_HTTPS_URL}" > /dev/null
	if [ "$?" -ne "0" ]; then
		echo "Error: HTTPS connection to ${OPENHPC_HTTPS_URL} failed." >&2
		echo "If you are behind proxy, make sure to export http_proxy and https_proxy variables" >&2
		exit 1
	fi
}

run_puppet() {
	export FACTER_hieradatadir="${SCRIPTDIR}/hieradata"
	puppet apply --hiera_config="${SCRIPTDIR}/hieradata/hiera.yaml" --modulepath="${SCRIPTDIR}/modules" "${SCRIPTDIR}/manifests/openhpc.pp"
}


main() {
	check_user
	#check_proxy
	run_puppet
}

main
