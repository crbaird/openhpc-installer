define ohpc_base::yumgroupchroot(
  $ohpc_repo_version = $::ohpc_base::ohpc_repo_version,
  $ohpc_repo_package = $::ohpc_base::ohpc_repo_package,
  $ohpc_repo_rpm = $::ohpc_base::ohpc_repo_rpm,
  $ohpc_repo = $::ohpc_base::ohpc_repo,
  $epel_repo = $::ohpc_base::epel_repo,
  $epel_rpm = $::ohpc_base::epel_rpm,
  $epel_package = $::ohpc_base::epel_package,
  $manage_epel = $::ohpc_base::manage_epel,
  $install_root = $::ohpc_base::chroot,
) {

  if $manage_epel {
    $ohpc_repo_require = []
  } else {
    $ohpc_repo_require = []
  }

  if $manage_epel {
    if ! defined(Package[$epel_package]) {
      package { $epel_package:
        ensure          => installed,
        install_options => "--installroot=${install_root} ",
        provider        => 'rpm',
        source          => "${epel_repo}/${epel_rpm}",
      }
    }
  }

  if ! defined(Package[$ohpc_repo_package]) {
    package { $ohpc_repo_package:
      ensure          => $ohpc_repo_version,
      install_options => "--installroot=${install_root} ",
      provider        => 'rpm',
      source          => "${ohpc_repo}/${ohpc_repo_rpm}",
      require         => $ohpc_repo_require,
    }
  }

  if $install_root {
    $root = "--installroot=${install_root} "
  }

  exec { "Installing ${name} yum group":
    path    => '/usr/bin',
    command => "yum -y groupinstall ${root} ${name}",
    onlyif  => "yum -y groupinfo ${root} ${name} | grep -q '^\s*+'",
    timeout => 600,
    require => Package[$ohpc_repo_package],
  }

}
