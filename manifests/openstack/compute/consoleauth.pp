class consul_profile::openstack::compute::consoleauth {
  include ::consul_profile::openstack::compute
  Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::consoleauth'
  }
}
