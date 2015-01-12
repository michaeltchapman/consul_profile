class consul_profile::openstack::network::l3 {
  include consul_profile::openstack::network

  Profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
    includes +> ['::neutron::agents::l3']
  }
}
