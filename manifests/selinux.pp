class profile::selinux {

  # I WASTED HOURS BECAUSE I THOUGHT HAVING SELINUX ON WAS THE CORRECT THING TO DO!
  class { '::selinux':
    mode => 'permissive'
  }
}
