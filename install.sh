#!/bin/bash

readonly OPENHPC_HTTP_URL="http://build.openhpc.community/"
readonly OPENHPC_HTTPS_URL="https://build.openhpc.community/"
readonly MODULES_GITHUB_ORG="https://github.intel.com/jdlugole"
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

install_puppet() {
	echo "Installing Puppet"
	rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
	yum -y install puppet
	if [ "$?" -ne "0" ]; then
		echo "Error: Failed to install Puppet" >&2
		echo "If your system is RHEL, make sure you have 'optional' channel enabled" >&2
		echo "To enable 'optional' channel, run: 'subscription-manager repos --enable rhel-7-server-optional-rpms'" >&2
		exit 1
	fi
}

install_module() {
	local module_name=$1
	[ -d "${SCRIPTDIR}/modules" ] || mkdir "${SCRIPTDIR}/modules"
	[ -f "${SCRIPTDIR}/${module_name}-master.tar.gz" ] && rm "${SCRIPTDIR}/${module_name}-master.tar.gz"
	curl -s -L "${MODULES_GITHUB_ORG}/${module_name}/archive/master.tar.gz" -o ${SCRIPTDIR}/${module_name}-master.tar.gz
	if [ "$?" -ne "0" ]; then
		echo "Error: failed to download module ${MODULES_GITHUB_ORG}/${module_name}/archive/master.tar.gz" >&2
		exit 1
	fi
	puppet module install --target-dir="${SCRIPTDIR}/modules" "${module_name}-master.tar.gz"
	if [ "$?" -ne "0" ]; then
		echo "Error: failed to install module $module_name" >&2
		exit 1
	fi
	rm ${SCRIPTDIR}/${module_name}-master.tar.gz
}

install_modules() {
	install_module "openhpc-ohpc_base"
	install_module "openhpc-ohpc_slurm"
	install_module "openhpc-ohpc_warewulf"
}

installation_complete() {
	echo "Installation Completed"
	echo "Modify hieradata/default.yaml configuration file and execute run-puppet.sh script"
}


main() {
	check_user
	check_proxy
	install_puppet
	install_modules
	installation_complete
}

main
