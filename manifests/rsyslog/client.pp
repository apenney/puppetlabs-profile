class profile::rsyslog::client(
  $server,
) {

  class { 'pe_rsyslog::client': server => $server, }
}
