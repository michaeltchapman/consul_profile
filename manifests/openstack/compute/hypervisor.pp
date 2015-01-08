class consul_profile::openstack::compute::hypervisor {
  include ::consul_profile::openstack::compute
  include ::consul_profile::openstack::network

  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> ['::nova::compute', '::nova::compute::spice']
  }

  if ! hiera('keystone_Address', false) {
    runtime_fail { 'novacomputekeystonedep':
      fail    => true,
      message => "Nova compute requires keystone_Address",
    }
  } else {
    if ! hiera('neutron-server_Address', false) {
      runtime_fail { 'novacomputekeystonedep':
        fail    => true,
        message => "Nova compute requires neutron-server_Address",
      }
    } else {
      Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
        includes +> ['::nova::compute::neutron']
      }
    }
  }
}
