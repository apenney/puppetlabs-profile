class profile::openstack::control(
  $public_address            = $ipaddress_bond0,
  $public_interface_address,
  $public_interface          = 'eth0',
  $private_interface         = 'eth1',
  $multi_host                = true,
  $db_root_password,
  $admin_email,
  $admin_password,
  $admin_token,
  $db_password,
  $region                    = 'default',
  $service_password,
  $console_secret,
  $fixed_range,
  $floating_range,
  $rpc_password,
  $verbase                   = true,
  $quantum                   = true,
) {

  include ::profile::openstack

  Class['profile::networking'] -> Class['profile::openstack::control']
  Class['profile::openstack'] -> Class['profile::openstack::control']

  network_config { 'bond0':
    ensure    => present,
    family    => 'inet',
    ipaddress => $public_interface_address,
    method    => 'static',
    netmask   => '255.255.254.0',
    onboot    => true,
    mtu       => '1500',
    options   => {
      'PEERDNS'      => 'no',
      'GATEWAY'      => '10.16.160.1',
      'BONDING_OPTS' => 'lacp_rate=fast miimon=100 mode=802.3ad xmit_hash_policy=layer2+3'
    },
  }

  network_config { [ 'eth0', 'eth1' ]:
    ensure => $ensure,
    method => static,
    onboot => true,
    mtu    => '1500',
    options    => {
      'MASTER' => 'bond0',
      'SLAVE'  => 'yes',
    },
    require => Network_config['bond0'],
    before  => Class['openstack::controller'],
    notify  => Service['network'],
  }
  service { 'network': ensure => running, }

  class { '::openstack::controller':
    public_address        => $public_address,
    public_interface      => $public_interface,
    private_interface     => $private_interface,
    mysql_root_password   => $db_root_password,
    admin_email           => $admin_email,
    admin_password        => $admin_password,
    keystone_db_password  => $db_password,
    keystone_admin_token  => $admin_token,
    region                => $region,
    glance_db_password    => $db_password,
    glance_user_password  => $service_password,
    nova_db_password      => $db_password,
    nova_user_password    => $service_password,
    cinder_db_password    => $db_password,
    cinder_user_password  => $service_password,
    secret_key            => $console_secret,
    fixed_range           => $fixed_range,
    floating_range        => $floating_range,
    multi_host            => $multi_host,
    db_host               => '127.0.0.1',
    db_type               => 'mysql',
    glance_api_servers    => '127.0.0.1:9292',
    rabbit_password       => $rpc_password,
    cache_server_ip       => '127.0.0.1',
    cache_server_port     => '11211',
    verbose               => $verbose,
    quantum               => $quantum,
    quantum_db_password   => $db_password,
    quantum_user_password => $service_password,
  }

  class { '::openstack::auth_file':
    admin_password        => $admin_password,
    keystone_admin_token => $admin_token,
    controller_node      => '127.0.0.1',
  }
}
