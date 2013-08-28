class profile::puppet::agent(
  $agent_certname    = $fqdn,
  $agent_environment = $environment,
  $master_hostname   = $servername,
) {

  ini_setting { 'agent certname':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'certname',
    value   => $agent_certname,
    ensure  => present,
  }

  ini_setting { 'master as archive':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'archive_file_server',
    value   => $master_hostname,
    ensure  => present,
  }

  ini_setting { 'master hostname':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'server',
    value   => $master_hostname,
    ensure  => present,
  }

  ini_setting { 'environment':
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'environment',
    value   => $agent_environment,
    ensure  => present,
  }

  cron { 'puppet_agent':
    minute  => fqdn_rand(60),
    command => "/usr/local/bin/puppet agent --no-daemonize --environment ${agent_environment} --onetime --splay --splaylimit 5 --verbose",
  }
}
