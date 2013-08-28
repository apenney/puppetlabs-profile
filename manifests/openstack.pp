class profile::openstack {

  $osver = regsubst($::operatingsystemrelease, '(\d+)\..*', '\1')

  yumrepo { 'rdo-release':
    baseurl  => "http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/epel-${osver}/",
    descr    => 'OpenStack Grizzly Repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-Grizzly',
    priority => 98,
  }
  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-RDO-Grizzly':
    source => 'puppet:///modules/openstack/RPM-GPG-KEY-RDO-Grizzly',
    owner  => root,
    group  => root,
    mode   => 644,
    before => Yumrepo['rdo-release'],
  }
  Yumrepo['rdo-release'] -> Package<||>
}
