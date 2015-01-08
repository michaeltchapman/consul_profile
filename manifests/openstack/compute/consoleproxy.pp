class consul_profile::openstack::compute::consoleproxy {
  include ::consul_profile::openstack::compute

  Profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
    includes +> '::nova::vncproxy'
  }
}
