class consul_profile::openstack::compute::consoleauth {
  include ::consul_profile::openstack::compute
  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::consoleauth'
  }
}
