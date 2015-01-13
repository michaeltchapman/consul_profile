class consul_profile::openstack::identity (
) {
  consul_profile::discovery::consul::datadep { 'keystonemysqldep':
    key       => 'mysql_Address',
    badvalues => ['127.0.0.1'],
    include   => ['::profile::openstack::identity','consul_profile::discovery::consul::identity']
  }

  consul_profile::discovery::consul::datadep { 'endpointskeystonedep':
    key    => 'keystone_Address',
    include => 'consul_profile::openstack::identity::endpoints'
  }
}
