class consul_profile::openstack::network::metadata {
  include profile::openstack::network
  include ::neutron::agents::metadata

  consul_profile::discovery::consul::datadep { 'neutronmetakeydep':
    key    => 'keystone_Address',
    caller => 'neutronmetakeystonemultidep'
  }

  consul_profile::discovery::consul::datadep { 'neutronmetanovadep':
    key    => 'nova-api_Address',
    before => [Class['::neutron::agents::metadata']]
  }

  consul_profile::discovery::consul::multidep { 'neutronmetakeystonemultidep':
    deps     => ['neutronmetakeydep','neutronmetanovadep'],
    includes => ['::neutron::agents::metadata',
                 '::consul_profile::openstack::network']
  }
}
