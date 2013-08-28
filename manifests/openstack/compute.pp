class profile::openstack::compute(
  $public_interface       = 'eth0',
  $private_interface      = 'eth1',
  $internal_address       = $ipaddress_eth0,
  $iscsi_ip_address       = $ipaddress_eth0,
  $libvirt_type           = 'kvm',
  $db_password            = hiera('profile::openstack::control::db_password'),
  $db_host                = hiera('profile::openstack::control::public_interface_address'),
  $multi_host             = true,
  $fixed_range            = hiera('profile::openstack::control::fixed_range'),
  $service_password       = hiera('profile::openstack::control::service_password'),
  $rpc_password           = hiera('profile::openstack::control::rpc_password'),
  $rabbit_host            = hiera('profile::openstack::control::public_interface_address'),
  $keystone_host          = hiera('profile::openstack::control::public_interface_address'),
  $glance_api_servers     = "${hiera('profile::openstack::control::public_interface_address')}:9292",
  $vncproxy_host          = hiera('profile::openstack::control::public_interface_address'),
  $vnc_enabled            = true,
  $verbose                = true,
  $quantum                = hiera('profile::openstack::control::quantum'),
) {

  include ::profile::openstack

  Class['profile::networking'] -> Class['profile::openstack::compute']
  Class['profile::openstack'] -> Class['profile::openstack::compute']

  $gateway = inline_template("<%= ('${network_eth0}'.split('.').slice(0, 3) << '1').join('.') %>")
  file_line { 'gateway':
    path => '/etc/sysconfig/network',
    line => "GATEWAY=${gateway}",
  }

  physical_volume { '/dev/sdb':
    ensure => present
  }

  volume_group { 'cinder-volumes':
    ensure           => present,
    physical_volumes => '/dev/sdb'
  }

  network_config { 'eth0':
    ensure    => present,
    family    => 'inet',
    method    => 'dhcp',
    onboot    => true,
    mtu       => '1500',
    options   => { 'DHCP_HOSTNAME' => $::hostname },
    before    => Class['::openstack::compute'],
    notify    => Service['network'],
  }

  network_config { 'eth1':
    ensure    => present,
    family    => 'inet',
    method    => 'none',
    onboot    => true,
    mtu       => '1500',
    before    => Class['::openstack::compute'],
    notify    => Service['network'],
  }

  service { 'network': ensure => running, }

  class { '::openstack::compute':
    public_interface      => $public_interface,
    private_interface     => $private_interface,
    internal_address      => $internal_address,
    iscsi_ip_address      => $iscsi_ip_address,
    libvirt_type          => $libvirt_type,
    db_host               => $db_host,
    multi_host            => $multi_host,
    fixed_range           => $fixed_range,
    nova_user_password    => $service_password,
    nova_db_password      => $db_password,
    cinder_db_password    => $db_password,
    rabbit_password       => $rpc_password,
    rabbit_host           => $rabbit_host,
    keystone_host         => $keystone_host,
    glance_api_servers    => $glance_api_servers,
    vncproxy_host         => $vncproxy_host,
    vnc_enabled           => $vnc_enabled,
    verbose               => $verbose,
    quantum               => $quantum,
    quantum_user_password => $service_password,
    quantum_db_password   => $db_password,
  }
}
