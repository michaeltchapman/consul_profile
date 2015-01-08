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
    profile::discovery::consul::datadep { 'ceiloendpointdep':
      key    => 'ceilometer-api_Address',
      include => 'ceilometer::keystone::auth'
    }
  }

  if $cinder {
    profile::discovery::consul::datadep { 'cinderendpointdep':
      key    => 'cinder-api_Address',
      include => 'cinder::keystone::auth'
    }
  }

  if $glance_enabled {
    profile::discovery::consul::datadep { 'glanceendpointdep':
      key    => 'glance-api_Address',
      include => 'glance::keystone::auth'
    }
  }

  if $neutron_enabled {
    profile::discovery::consul::datadep { 'neutronendpointdep':
      key    => 'neutron-server_Address',
      badvalues => ['127.0.0.1'],
      include => 'neutron::keystone::auth'
    }
  }

  if $nova_enabled {
    profile::discovery::consul::datadep { 'novaendpointdep':
      key    => 'nova-api_Address',
      include => 'nova::keystone::auth'
    }
  }

  if $swift_enabled {
    profile::discovery::consul::datadep { 'swiftendpointdep':
      key    => 'swift-proxy_Address',
      include => ['swift::keystone::auth','swift::keystone::dispersion']
    }
  }

  if $trove_enabled {
    profile::discovery::consul::datadep { 'troveendpointdep':
      key    => 'trove-api_Address',
      include => ['trove::keystone::auth']
    }
  }

}
