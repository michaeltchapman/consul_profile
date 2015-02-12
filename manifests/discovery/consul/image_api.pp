#
class consul_profile::discovery::consul::image_api (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'glance-api':
    port    => 9292,
    require => Service['glance-api'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'glance-api':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
