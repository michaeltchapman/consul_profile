class consul_profile::openstack::image::registry (
) {
  consul_profile::discovery::consul::multidep { 'glanceregmultidep':
    deps     => ['glanceregkeystonedep','glanceregmysqldep'],
    includes => ['::profile::openstack::image::registry', '::consul_profile::discovery::consul::image_registry'],
  }

  if ! hiera('mysql_Address', false) {
    runtime_fail { 'glanceregmysqldep':
      fail    => true,
      message => "glanceregmysqldep: requires mysql_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceregmultidep' |> {
      response +> 'glanceregmysqldep'
    }
  }

  if ! hiera('keystone_Address', false) {
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
