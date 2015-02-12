class consul_profile::openstack::identity::endpoints (
  $ceilometer_enabled = true,
  $cinder_enabled     = true,
  $glance_enabled     = true,
  $neutron_enabled    = true,
  $nova_enabled       = true,
  $swift_enabled      = true,
  $trove_enabled      = true,
) {

  if $ceilometer_enabled {
    consul_profile::discovery::consul::datadep { 'ceiloendpointdep':
      key    => 'service_hash__haproxy::balanced__ceilometer-api__Address',
      include => 'ceilometer::keystone::auth'
    }
  }

  if $cinder {
    consul_profile::discovery::consul::datadep { 'cinderendpointdep':
      key    => 'service_hash__haproxy::balanced__cinder-api__Address',
      include => 'cinder::keystone::auth'
    }
  }

  if $glance_enabled {
    consul_profile::discovery::consul::datadep { 'glanceendpointdep':
      key    => 'service_hash__haproxy::balanced__glance-api__Address',
      include => 'glance::keystone::auth'
    }
  }

  if $neutron_enabled {
    consul_profile::discovery::consul::datadep { 'neutronendpointdep':
      key    => 'service_hash__haproxy::balanced__neutron-server__Address',
      badvalues => ['127.0.0.1'],
      include => 'neutron::keystone::auth'
    }
  }

  if $nova_enabled {
    consul_profile::discovery::consul::datadep { 'novaendpointdep':
      key    => 'service_hash__haproxy::balanced__nova-api__Address',
      include => 'nova::keystone::auth'
    }
  }

  if $swift_enabled {
    consul_profile::discovery::consul::datadep { 'swiftendpointdep':
      key    => 'service_hash__haproxy::balanced__swift-proxy__Address',
      include => ['swift::keystone::auth','swift::keystone::dispersion']
    }
  }

  if $trove_enabled {
    consul_profile::discovery::consul::datadep { 'troveendpointdep':
      key    => 'service_hash__haproxy::balanced__trove-api__Address',
      include => ['trove::keystone::auth']
    }
  }

}
