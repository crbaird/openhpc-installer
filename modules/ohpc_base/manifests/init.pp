# === Authors
#
# Jakub Dlugolecki <jakub.dlugolecki@intel.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ohpc_base(
  $ohpc_repo_version = $::ohpc_base::params::ohpc_repo_version,
  $ohpc_repo_package = $::ohpc_base::params::ohpc_repo_package,
  $ohpc_repo_rpm = $::ohpc_base::params::ohpc_repo_rpm,
  $ohpc_repo = $::ohpc_base::params::ohpc_repo,
  $epel_repo = $::ohpc_base::params::epel_repo,
  $epel_rpm = $::ohpc_base::params::epel_rpm,
  $epel_package = $::ohpc_base::params::epel_package,
  $manage_epel = $::ohpc_base::params::manage_epel,
  $manage_ntp = $::ohpc_base::params::manage_ntp,
  $ntp_servers = $::ohpc_base::params::ntp_servers,
  $chroot = $::ohpc_base::params::chroot,
) inherits ohpc_base::params {

  ohpc_base::yumgroup { 'ohpc-base':
  }

  if $manage_ntp {
    class { '::ntp':
      servers => $ntp_servers
    }
  }
}
