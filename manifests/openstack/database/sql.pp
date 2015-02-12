class consul_profile::openstack::database::sql {

  consul_profile::discovery::consul::datadep { 'dbmysqldep':
    key       => 'service_hash__haproxy::balanced__mysql__Address',
    badvalues => ['127.0.0.1'],
    include   => ['profile::openstack::database::sql']
  }
}
