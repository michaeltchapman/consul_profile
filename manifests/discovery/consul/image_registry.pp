#
class consul_profile::discovery::consul::image_registry (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'glance-registry':
    port    => 9191,
    require => Service['glance-registry'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'glance-registry':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
