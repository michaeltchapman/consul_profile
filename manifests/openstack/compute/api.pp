class consul_profile::openstack::compute::api {
  include ::consul_profile::openstack::compute

  if ! hiera('keystone_Address', false) {
    runtime_fail { 'novaapikeystonedep':
      fail    => true,
      message => "Nova api requires keystone_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
      includes +> ['::nova::api', '::profile::discovery::consul::compute_api']
    }
  }
}
