class consul_profile::openstack::identity (
) {
  consul_profile::discovery::consul::datadep { 'keystonemysqldep':
    key       => 'service_hash__haproxy::balanced__mysql__Address',
    badvalues => ['127.0.0.1'],
    include   => ['::profile::openstack::identity','consul_profile::discovery::consul::identity']
  }

  consul_profile::discovery::consul::datadep { 'endpointskeystonedep':
    key    => 'service_hash__haproxy::balanced__keystone__Address',
    include => 'consul_profile::openstack::identity::endpoints'
  }
}
