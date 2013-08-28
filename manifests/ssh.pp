class profile::ssh {

  include ::ssh::server
  ssh::server::configline { 'PermitRootLogin': value  => 'without-password', }
  ssh::server::configline { 'PubkeyAuthentication': value  => 'yes', }
}
