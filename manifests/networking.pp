class profile::networking {
  file_line { 'dhcp hostname':
    path => '/etc/sysconfig/network',
    line => "HOSTNAME=${hostname}",
  }
}
