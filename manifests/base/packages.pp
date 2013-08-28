class profile::base::packages(
  $proxy = 'http://proxy.puppetlabs.net:3128',
) {

  class { '::epel': proxy => $proxy } -> Package <| |>
}
