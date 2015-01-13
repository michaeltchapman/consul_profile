#
class consul_profile::discovery::consul::network_server (
) {
  consul::service { 'neutron-server':
    port    => 9696,
    require => Service['neutron-server']
  }
}
