class consul_profile::openstack::compute::api {
  include ::consul_profile::openstack::compute

  if ! hiera('service_hash__haproxy::balanced__keystone_Address', false) {
    runtime_fail { 'novaapikeystonedep':
      fail    => true,
      message => "Nova api requires keystone_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
      includes +> ['::profile::openstack::compute::api', '::consul_profile::discovery::consul::compute_api']
    }
  }
}
