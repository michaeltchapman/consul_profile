class consul_profile::openstack::network::l3 {
  include consul_profile::openstack::network

  Consul_profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
    includes +> ['::neutron::agents::l3']
  }
}
