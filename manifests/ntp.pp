class profile::ntp(
  $servers = 'time.puppetlabs.net'
) {

  class { '::ntp': servers => $servers, }
  file { '/etc/dhcp/dhclient.d/ntp.sh': mode => '0644', }
}
