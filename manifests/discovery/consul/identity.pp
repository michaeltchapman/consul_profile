#
class consul_profile::discovery::consul::identity (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'keystone':
    port    => 5000,
    require => Service['keystone'],
    tags    => ['haproxy::balancemember']
  }

  # We actually cheat a bit with this. We assume that it's available wherever keystone is
  # which is not always true.
  consul::service { 'keystone-admin':
    port    => 35357,
    require => Service['keystone'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'keystone':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }

  consul_profile::discovery::consul::haproxy_service { 'keystone-admin':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
