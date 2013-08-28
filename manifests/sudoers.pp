class profile::sudoers(
  $users,
) {

  include ::sudo
  $users.each { |$user|
    sudo::rule { "${user}_no_passwd":
      ensure   => present,
      who      => $user,
      commands => 'ALL',
      nopass   => true,
      comment  => "${user} is lazy and doesn't want to type their password",
    }
  }
}
