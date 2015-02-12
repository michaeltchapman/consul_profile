class consul_profile::openstack::network::metadata {
  include profile::openstack::network
  include ::neutron::agents::metadata

  consul_profile::discovery::consul::datadep { 'neutronmetakeydep':
    key    => 'service_hash__haproxy::balanced__keystone__Address',
    caller => 'neutronmetakeystonemultidep'
  }

  consul_profile::discovery::consul::datadep { 'neutronmetanovadep':
    key    => 'service_hash__haproxy::balanced__nova-api__Address',
    before => [Class['::neutron::agents::metadata']]
  }

  consul_profile::discovery::consul::multidep { 'neutronmetakeystonemultidep':
    deps     => ['neutronmetakeydep','neutronmetanovadep'],
    includes => ['::neutron::agents::metadata',
                 '::consul_profile::openstack::network']
  }
}
