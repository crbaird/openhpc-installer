# == Class: ohpc_slurm
#
# Full description of class ohpc_slurm here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'ohpc_slurm':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ohpc_slurm(
  $chroot = 'undef',
) {

  user { 'slurm':
    ensure => present,
    system => true,
  }

  ohpc_base::yumgroup { 'ohpc-slurm-server':
    require => User['slurm'],
  }

  ohpc_base::yumgroupchroot { 'ohpc-slurm-client':
    install_root => "$chroot",
    require      => Exec['wwmkchroot'],
  }

  package { 'slurm-pam_slurm-ohpc':
    ensure               => installed,
    install_options      => "--installroot=${chroot}",
    require              => [Exec['wwmkchroot'], Ohpc_base::Yumgroup['ohpc-warewulf']],
    notify               => Exec['create vnfs'],
  }
}
