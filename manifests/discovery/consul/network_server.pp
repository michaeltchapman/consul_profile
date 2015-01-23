#
class consul_profile::discovery::consul::network_server (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'neutron-server':
    port    => 9696,
    require => Service['neutron-server'],
    tags    => $::consul_profile::discovery::consul::params::openstack_api_tags
  }
}
