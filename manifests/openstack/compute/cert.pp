class consul_profile::openstack::compute::cert {
  include ::consul_profile::openstack::compute

  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::cert'
  }
}
