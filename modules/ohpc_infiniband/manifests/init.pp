# === Authors
#
# Jakub Dlugolecki <jakub.dlugolecki@intel.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ohpc_infiniband(
  $sms_ipoib = 'undef',
  $ipoib_netmask = 'undef',
)
{

  ohpc_base::yumgroup { 'InfiniBand Support':
  }

  package { 'infinipath-psm':
    ensure  => installed,
    require => Ohpc_base::Yumgroup['InfiniBand Support'],
  }

  service { 'rdma':
    ensure  => running,
    enable  => true,
    require => Package['infinipath-psm'],
  }

  limits::fragment {
    '*/soft/memlock':
      value => 'unlimited';
    '*/hard/memlock':
      value => 'unlimited';
  }

  if $sms_ipoib != 'undef' and $ipoib_netmask != 'undef' {

    # Enable IPoIB
    file { '/etc/sysconfig/network-scripts/ifcfg-ib0':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('ohpc_infiniband/ifcfg-ib0.erb'),
      notify  => Exec['initiate ib0'],
      require => Package['infinipath-psm'],
    }

    package { 'initscripts':
      ensure => installed,
    }

    exec { 'initiate ib0':
      path        => ['/usr/sbin', '/usr/bin'],
      onlyif      => 'ifconfig | grep -q ib0',
      command     => 'ifup ib0',
      refreshonly => true,
      require     => [Package['initscripts'], File['/etc/sysconfig/network-scripts/ifcfg-ib0'], Service['rdma']],
    }

  } else {
    notify { 'Skipping IPoIB configuration because sms_ipoib or ipoib_netmask are not configured': }
  }

}
