class consul_profile::openstack::database::sql {

  profile::discovery::consul::datadep { 'dbmysqldep':
    key       => 'mysql_Address',
    badvalues => ['127.0.0.1'],
    include   => ['profile::openstack::database::sql']
  }
}
