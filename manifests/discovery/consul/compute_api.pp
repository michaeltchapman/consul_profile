#
class consul_profile::discovery::consul::compute_api (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'nova-api':
    port    => 8774,
    require => Service['nova-api'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'nova-api':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }

  consul::service { 'nova-api-ec2':
    port    => 8773,
    require => Service['nova-api'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'nova-api-ec2':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }

  consul::service { 'nova-api-metadata':
    port    => 8775,
    require => Service['nova-api'],
    tags    => ['haproxy::balancemember']
  }

  consul_profile::discovery::consul::haproxy_service { 'nova-api-metadata':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
