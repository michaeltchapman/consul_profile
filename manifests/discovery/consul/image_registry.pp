#
class profile::discovery::consul::image_registry (
) {
  profile::discovery::consul::datadep { 'glanceregmysqldep':
    key       => 'mysql_Address',
    badvalues => ['127.0.0.1'],
    caller    => 'glanceregmultidep'
  }

  profile::discovery::consul::datadep { 'glanceregkeystonedep':
    key       => 'keystone_Address',
    caller    => 'glanceregmultidep'
  }

  profile::discovery::consul::multidep { 'glanceregmultidep':
    deps     => ['glanceregkeystonedep','glanceregmysqldep'],
    includes => ['::glance::registry', '::profile::discovery::consul::services::image_registry']
  }
}
