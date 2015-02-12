class consul_profile::openstack::compute::hypervisor (
  $hypervisor_type = 'libvirt'
) {
  include ::consul_profile::openstack::compute
  include ::consul_profile::openstack::network

  Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> ['::nova::compute', '::nova::compute::spice', "::nova::compute::${hypervisor_type}"]
  }

  if ! hiera('service_hash__haproxy::balanced__keystone__Address', false) {
    runtime_fail { 'novacomputekeystonedep':
      fail    => true,
      message => "Nova compute requires keystone_Address",
    }
  } else {
    if ! hiera('service_hash__haproxy::balanced__neutron-server__Address', false) {
      runtime_fail { 'novacomputekeystonedep':
        fail    => true,
        message => "Nova compute requires neutron-server_Address",
      }
    } else {
      Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
        includes +> ['::nova::compute::neutron']
      }
    }
  }
}
