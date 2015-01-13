class consul_profile::openstack::network::dhcp {
  include consul_profile::openstack::network

  Consul_profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
    includes +> ['::neutron::agents::dhcp']
  }
}
