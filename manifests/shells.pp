class profile::shells {

  package { [ 'bash', 'zsh' ]: ensure => present, }

}
