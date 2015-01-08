class consul_profile::openstack::compute::conductor {
  include ::consul_profile::openstack::compute

  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::conductor'
  }
}
