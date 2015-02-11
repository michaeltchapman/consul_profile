#
class consul_profile::discovery::consul::network_server (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'neutron-server':
    port    => 9696,
    require => Service['neutron-server'],
  }

  consul_profile::discovery::consul::haproxy_service { 'neutron-server':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
