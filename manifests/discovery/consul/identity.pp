#
class consul_profile::discovery::consul::identity (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'keystone':
    port    => 5000,
    require => Service['keystone'],
  }

  consul_profile::discovery::consul::haproxy_service { 'keystone':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
