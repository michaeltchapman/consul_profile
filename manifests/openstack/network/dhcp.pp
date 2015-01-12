class consul_profile::openstack::network::dhcp {
  include consul_profile::openstack::network

  Profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
    includes +> ['::neutron::agents::dhcp']
  }
}
