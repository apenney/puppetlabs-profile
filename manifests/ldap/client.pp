class profile::ldap::client(
  $uri           = 'ldap://ldap.puppetlabs.com',
  $base          = 'dc=puppetlabs,dc=com',
  $ssl           = true,
  $ssl_cert_path = [
    'puppet:///modules/profile/ldap/client/GeoTrust_Primary_CA.pem',
    'puppet:///modules/profile/ldap/client/GeoTrust_Global_CA.pem',
  ],
  $ssl_reqcert   = 'hard',
  $nsswitch      = true,
  $nss_passwd    = 'ou=users',
  $nss_shadow    = 'ou=users',
  $nss_group     = 'ou=groups',
  $nslcd         = true,
  $binddn        = 'cn=ldapauth,ou=users,dc=puppetlabs,dc=com',
  $bindpw,
) {

  class { 'ldap':
    uri           => $uri,
    base          => $base,
    ssl           => $ssl,
    ssl_cert_path => $ssl_cert_path,
    ssl_reqcert   => $ssl_reqcert,
    nsswitch      => $nsswitch,
    nss_passwd    => $nss_passwd,
    nss_shadow    => $nss_shadow,
    nss_group     => $nss_group,
    binddn        => $binddn,
    bindpw        => $bindpw,
    nslcd         => $nslcd,
  }

  class { 'pam::pamd': pam_ldap => true, }

  name_service { [ 'passwd', 'group', 'shadow' ]:
    lookup => ['files', 'ldap'],
  }
}
