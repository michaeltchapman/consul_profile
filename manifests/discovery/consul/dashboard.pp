#
class consul_profile::discovery::consul::dashboard
{
  include consul_profile::discovery::consul::params

  consul::service { 'horizon':
    port    => 80,
    require => Service[$::horizon::params::http_service],
    tags    => ['haproxy::balancemember'],
  }

  consul_profile::discovery::consul::haproxy_service { 'horizon':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
