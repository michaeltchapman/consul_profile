class consul_profile::openstack::compute {

  if ! hiera('service_hash__haproxy::balanced__mysql_Address', false) {
    runtime_fail { 'novadbdep':
      fail    => true,
      message => "novadbdep: requires haproxy balanced mysql_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novadbdep'
    }
  }

  if ! hiera('service_hash__haproxy::balanced__glance-api__Address', false) {
    runtime_fail { 'novaglancedep':
      fail    => true,
      message => "novaglancedep: requires glance-api_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novaglancedep'
    }
  }

  if ! hiera('rabbitmq_Address', false) {
    runtime_fail { 'novarabbitmqdep':
      fail    => true,
      message => "novarabbitmqdep: requires rabbitmq_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
      response +> 'novarabbitmqdep'
    }
  }


  # nova::network::neutron has to be separate because of
  # data dep cycle between nova-api and neutron-server
  if ! hiera('service_hash__haproxy::balanced__keystone__Address', false) {
    runtime_fail { 'novakeystonedep':
      fail    => true,
      message => "novakeystonedep: requires keystone_Address",
    }
  } else {
    if ! hiera('service_hash__haproxy::balanced__neutron-server__Address', false) {
      runtime_fail { 'novaneutronserverdep':
        fail    => true,
        message => "novaneutronserverdep: requires neutron-server_Address",
      }
    } else {
      Consul_profile::Discovery::Consul::Multidep<| title == 'novamultidep' |> {
        includes +> ['::nova::network::neutron']
      }
    }
  }

  consul_profile::discovery::consul::multidep { 'novamultidep':
    deps     => ['novarabbitmqdep','novaglancedep','novadbdep'],
    includes => ['::nova']
  }
}
