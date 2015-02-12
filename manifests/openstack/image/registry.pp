class consul_profile::openstack::image::registry (
) {
  consul_profile::discovery::consul::multidep { 'glanceregmultidep':
    deps     => ['glanceregkeystonedep','glanceregmysqldep'],
    includes => ['::profile::openstack::image::registry', '::consul_profile::discovery::consul::image_registry'],
  }

  if ! hiera('service_hash__haproxy::balanced__mysql__Address', false) {
    runtime_fail { 'glanceregmysqldep':
      fail    => true,
      message => "glanceregmysqldep: requires mysql_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceregmultidep' |> {
      response +> 'glanceregmysqldep'
    }
  }

  if ! hiera('service_hash__haproxy::balanced__keystone__Address', false) {
    runtime_fail { 'glanceregkeystonedep':
      fail    => true,
      message => "glanceregmysqldep: requires keystone_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceregmultidep' |> {
      response +> 'glanceregkeystonedep'
    }
  }

}
