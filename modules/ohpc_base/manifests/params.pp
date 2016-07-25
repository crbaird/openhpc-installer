class ohpc_base::params {

  $ohpc_repo_version = '1.1-1'
  $ohpc_repo_package = 'ohpc-release'
  $manage_epel = true
  $manage_ntp = false
  $ntp_servers = [ '127.0.0.1' ]
  $chroot = '/opt/ohpc/admin/images/centos7.2'

  if $::osfamily == 'RedHat' and $::operatingsystemrelease =~ /^7\.2/ {
    $ohpc_repo = 'https://github.com/openhpc/ohpc/releases/download/v1.1.GA'
    $epel_repo = 'https://dl.fedoraproject.org/pub/epel'
    $epel_package = 'epel-release'
    $epel_rpm = "${epel_package}-latest-${::operatingsystemmajrelease}.noarch.rpm"
    $ohpc_repo_rpm = "${ohpc_repo_package}-centos7.2-${ohpc_repo_version}.x86_64.rpm"
  } elsif $::osfamily == 'Suse' and $::operatingsystemmajrelease == '12' {
    $ohpc_repo = 'https://github.com/openhpc/ohpc/releases/download/v1.1.GA/'
    $ohpc_repo_rpm = "${ohpc_repo_package}-sles12sp1-${ohpc_repo_version}.x86_64.rpm"
  } else {
    fail("Class['ohpc_base']: Unsupported Operating System")
  }

}
