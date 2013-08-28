class profile::base {
  include profile::ldap::client
  include profile::autofs
  include profile::root
  include profile::sudoers
  include profile::ssh
  include profile::puppet::agent
  include profile::ntp
  include profile::rsyslog::client
  include profile::selinux
  include profile::networking
  include profile::shells
  include profile::base::packages
}
