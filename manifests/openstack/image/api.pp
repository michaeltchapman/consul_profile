class consul_profile::openstack::image::api(
) {

  if ! hiera('service_hash__haproxy::balanced__mysql__Address', false) {
    runtime_fail { 'glanceapimysqldep':
      fail    => true,
      message => "Glance api requires mysql_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceapimultidep' |> {
      response +> 'glanceapimysqldep'
    }
  }

  if ! hiera('service_hash__haproxy::balanced__keystone__Address', false) {
    runtime_fail { 'glanceapikeystonedep':
      fail    => true,
      message => "Glance api requires keystone_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceapimultidep' |> {
      response +> 'glanceapikeystonedep'
    }
  }

  if ! hiera('service_hash__haproxy::balanced__glance-registry__Address', false) {
    runtime_fail { 'glanceapiregistrydep':
      fail    => true,
      message => "Glance api requires glance-registry_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep<| title == 'glanceapimultidep' |> {
      response +> 'glanceapiregistrydep'
    }
  }

  consul_profile::discovery::consul::multidep { 'glanceapimultidep':
    deps     => ['glanceapikeystonedep','glanceapimysqldep','glanceapiregistrydep'],
    includes => ['::profile::openstack::image::api', 'consul_profile::discovery::consul::image_api']
  }
}
