class consul_profile::openstack::compute {

  if ! hiera('mysql_Address', false) {
    runtime_fail { 'novadbdep':
      fail    => true,
      message => "novadbdep: requires mysql_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novadbdep'
    }
  }

  if ! hiera('glance-api_Address', false) {
    runtime_fail { 'novaglancedep':
      fail    => true,
      message => "novaglancedep: requires glance-api_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novaglancedep'
    }
  }

  if ! hiera('rabbitmq_Address', false) {
    runtime_fail { 'novarabbitmqdep':
      fail    => true,
      message => "novarabbitmqdep: requires rabbitmq_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novarabbitmqdep'
    }
  }

  if ! hiera('keystone_Address', false) {
    runtime_fail { 'novakeystonedep':
      fail    => true,
      message => "novakeystonedep: requires keystone_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novakeystonedep'
    }
  }

  profile::discovery::consul::multidep { 'novamultidep':
    deps     => ['novarabbitmqdep','novaglancedep','novadbdep','novakeystonedep'],
    includes => ['::nova','::nova::network::neutron']
  }

}

novarabbitmqdep novaglancedep novadbdep novakeystonedep
novakeystonedep novaglancedep novarabbitmqdep novakeystonedep
