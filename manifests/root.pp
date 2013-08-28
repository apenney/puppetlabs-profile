class profile::root(
  $hash,
) {

  exec { 'use sha512':
    command => 'authconfig --passalgo=sha512 --update',
    unless  => 'authconfig --test | grep sha512',
    path    => [ '/usr/sbin', '/usr/bin', '/bin' ],
    before  => User['root'],
  }

  user { 'root':
    ensure   => present,
    comment  => 'root',
    gid      => 0,
    home     => '/root',
    password => $hash,
    shell    => '/bin/bash',
    uid      => 0,
  }

  ssh_authorized_key { 'bd_root':
    ensure => present,
    type   => 'ssh-rsa',
    user   => 'root',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDM4k9CNzL9tME5Rxf6PwF/vEDdVUMCGlujBYY6l2x59C+l3dvyWd8idrMmQ9SlZmOXy7M17bW2ec0cRkeiNSn6TWNMcQ35e+KeadpLLkeD2en2koY38N7o97BCSKJrpbN3Htp1V5x35T7HiQLgAgoZlsbnj6YJp6ZiDQ9eIf/g76vLkGBINgEFT77f7HGAue9Uthr4sYq2aeyRfSKrc+zR2idT2hpiK+s/9OCSj6G9IWQr0pz6OATD0tbLicvWFgP7+B4sr54p7hNPHxskhbXBqSXUl2Q5GTdGwY6A9hTstCEXpxmNn3y0jdU3PFDUobcKmNOxoT0Xa4eLfPY/2CUuxMPYKLpregt9zNtNYyOylZ7uAH+kSkjPFAJ8IyDANWsk2kYtv1CsFUysgosl8P76gKxAtapEnpMTTXodblLCI3cK8n0+M8TTapEg/fZL74/zf4RzmpChhbSG9Q/1KrNIEDoiW4TiTEjDx8rh4TR4fRdUn+l45IwAiPQu/9PbNaeQNx2izE3G/7yM48/cFaNVrT6Z8OP6kECLfYTf9ELVS+pcDfxvBl6lSobTWvovUk6Fup3Y2kTjcMPzadwi0IlEsyM2+jLtCFqsgq0RvQiZJJXTk8Ek7xVrS6UOqhJP+d7w8wv9zGnrNyDZqfMz3KmCgWta+MId6vymtfiv9RpSEQ==',
  }
}
