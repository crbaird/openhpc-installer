$manage_firewall = hiera('manage_firewall', true)
$manage_epel = hiera('manage_epel', true)
$chroot = hiera('chroot', 'undef')
$os_template = hiera('os_template', 'undef')
$sms_ip = hiera('sms_ip', 'undef')
$sms_eth_internal = hiera('sms_eth_internal', 'undef')
$internal_netmask = hiera('internal_netmask', 'undef')
$manage_ntp = hiera('manage_ntp', true)
$ntp_servers = hiera_array('ntp_servers', ['127.0.0.1'])

class { 'ohpc_base':
  manage_epel => $manage_epel,
  manage_ntp  => $manage_ntp,
  ntp_servers => $ntp_servers,
}

class { 'ohpc_warewulf':
  chroot           => $chroot,
  os_template      => $os_template,
  sms_eth_internal => $sms_eth_internal,
  sms_ip           => $sms_ip,
  internal_netmask => $internal_netmask,
  manage_firewall  => $manage_firewall,
}

class { 'ohpc_slurm':
  chroot           => $chroot,
}

Class['ohpc_base'] -> Class['ohpc_warewulf']
Class['ohpc_base'] -> Class['ohpc_slurm']

