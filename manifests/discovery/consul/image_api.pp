#
class profile::discovery::consul::image_api (
) inherits profile::openstack::image::api {
  profile::discovery::consul::datadep { 'glanceapimysqldep':
    key       => 'mysql_Address',
    badvalues => ['127.0.0.1'],
    caller    => 'glanceapimultidep'
  }

  profile::discovery::consul::datadep { 'glanceapikeystonedep':
    key       => 'keystone_Address',
    caller    => 'glanceapimultidep'
  }

  profile::discovery::consul::datadep { 'glanceapiregistrydep':
    key       => 'glance-registry_Address',
    caller    => 'glanceapimultidep'
  }

  profile::discovery::consul::multidep { 'glanceapimultidep':
    deps     => ['glanceapikeystonedep','glanceapimysqldep','glanceapiregistrydep'],
    includes => ['::glance::api', 
                 '::profile::discovery::consul::services::image_api',
                 '::glance::cache::pruner',
                 '::glance::cache::cleaner',
                 '::glance::backend::${backend}']
  }
}
