class consul_profile::openstack::compute::cert {
  include ::consul_profile::openstack::compute

  Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::cert'
  }
}
