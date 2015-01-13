class consul_profile::openstack::compute::scheduler {
  include ::consul_profile::openstack::compute

  Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::scheduler'
  }
}
