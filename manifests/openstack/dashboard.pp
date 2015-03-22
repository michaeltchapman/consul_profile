class consul_profile::openstack::dashboard {

  consul_profile::discovery::consul::datadep { 'horizonkeystonedep':
    key    => 'service_hash__haproxy::balanced__keystone__Address',
    include => ['::profile::openstack::dashboard',
                '::consul_profile::discovery::consul::dashboard']
  }
}
