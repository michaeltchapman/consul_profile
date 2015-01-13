class consul_profile::openstack::network {

  consul_profile::discovery::consul::multidep { 'neutronmultidep':
    deps     => ['neutronrabbitmqdep'],
    includes => ['::profile::openstack::network']
  }

  if ! hiera('rabbitmq_Address', false) {
    runtime_fail { 'neutronrabbitmqdep':
      fail    => true,
      message => "neutron requires rabbitmq_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
      response +> ['neutronrabbitmqdep']
    }
  }
  Neutron_config<| title == 'database/connection' |> ~> Exec<| title == 'neutron-db-sync' |>
}
