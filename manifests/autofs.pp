class profile::autofs(
  $nfs4_domain = $domain,
) {

  ::autofs::mount { '/home':
    map     => '/etc/auto.home',
    options => '-fstype=nfs4,rw,hard,intr,nosuid,nobrowse',
  }

  file { '/etc/auto.home':
    content => '* nfs.bd.eng.puppetlabs.net:/volumes/tank01/home/&',
  }

  package { 'nfs-utils': ensure => present, }

  # Because I've never convined Linux to actually use its DNS domain.
  ini_setting { 'nfs4_domain':
    path    => '/etc/idmapd.conf',
    section => 'General',
    setting => 'Domain',
    value   => $nfs4_domain,
    ensure  => present,
    require => Package['nfs-utils'],
  }
}
