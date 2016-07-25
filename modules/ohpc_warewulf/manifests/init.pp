# === Authors
#
# Jakub Dlugolecki <jakub.dlugolecki@intel.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ohpc_warewulf(
  $chroot = 'undef',
  $os_template = 'undef',
  $sms_eth_internal = 'undef',
  $sms_ip = 'undef',
  $internal_netmask = 'undef',
  $manage_firewall = $::ohpc_warewulf::params::manage_firewall,
) inherits ohpc_warewulf::params {

  ohpc_base::yumgroup { 'ohpc-warewulf':
  }

  file { "/etc/sysconfig/network-scripts/ifcfg-${sms_eth_internal}":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['restart provisioning interface'],
    content => template('ohpc_warewulf/ifcfg-eth-internal.erb'),
  }

  exec { 'restart provisioning interface':
    refreshonly => true,
    path        => ['/usr/sbin', '/usr/bin'],
    command     => "ifdown ${sms_eth_internal}; ifup ${sms_eth_internal} || true",
    require     => File["/etc/sysconfig/network-scripts/ifcfg-${sms_eth_internal}"],
  }

  file { '/etc/warewulf/provision.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ohpc_warewulf/provision.conf.erb'),
    require => Ohpc_base::Yumgroup['ohpc-warewulf'],
  }

  file { '/etc/xinetd.d/tftp':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ohpc_warewulf/tftp',
    require => [Ohpc_base::Yumgroup['ohpc-warewulf']],
    notify  => Service['xinetd'],
  }

  service { 'xinetd':
    ensure  => running,
    enable  => true,
    require => File['/etc/xinetd.d/tftp'],
  }

  file { '/etc/httpd/conf.d/warewulf-httpd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ohpc_warewulf/warewulf-httpd.conf',
    require => Ohpc_base::Yumgroup['ohpc-warewulf'],
    notify  => Service['httpd'],
  }

  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => File['/etc/httpd/conf.d/warewulf-httpd.conf'],
  }

  service { 'mariadb':
    ensure  => running,
    enable  => true,
    require => Ohpc_base::Yumgroup['ohpc-warewulf'],
  }

  if $manage_firewall {
    if ! defined(Service['firewalld']) {
      service { 'firewalld':
        ensure => stopped,
        enable => false,
      }
    }
  }

  exec { 'wwmkchroot':
    refreshonly => true,
    path        => ['/usr/sbin', '/usr/bin'],
    command     => "wwmkchroot ${os_template} ${chroot}",
    require     => Ohpc_base::Yumgroup['ohpc-warewulf'],
  }

  exec { 'create vnfs':
    refreshonly => true,
    path        => ['/usr/sbin', '/usr/bin'],
    command     => "wwvnfs -y --chroot ${chroot}",
    require     => Ohpc_base::Yumgroup['ohpc-warewulf'],
  }

}
