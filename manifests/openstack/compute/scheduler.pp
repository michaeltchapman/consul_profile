class consul_profile::openstack::compute::scheduler {
  include ::consul_profile::openstack::compute

  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::scheduler'
  }
}
