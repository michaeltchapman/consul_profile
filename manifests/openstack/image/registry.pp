class consul_profile::openstack::image::registry (
) {
  profile::discovery::consul::multidep { 'glanceregmultidep':
    deps     => ['glanceregkeystonedep','glanceregmysqldep'],
    includes => ['::profile::openstack::image::registry', '::profile::discovery::consul::image_registry'],
  }

  if ! hiera('mysql_Address', false) {
    runtime_fail { 'glanceregmysqldep':
      fail    => true,
      message => "glanceregmysqldep: requires mysql_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'glanceregmultidep' |> {
      response +> 'glanceregmysqldep'
    }
  }

  if ! hiera('keystone_Address', false) {
    runtime_fail { 'glanceregkeystonedep':
      fail    => true,
      message => "glanceregmysqldep: requires keystone_Address",
    }
  } else {
    Profile::Discovery::Consul::Multidep<| title == 'glanceregmultidep' |> {
      response +> 'glanceregkeystonedep'
    }
  }

}
