class consul_profile::openstack::network::controller {
  include ::consul_profile::openstack::network

  if ! hiera('mysql_Address', false) {
    runtime_fail { 'neutronserverdbdep':
      fail    => true,
      message => "neutron-server requires mysql_Address",
    }
  } else {

    if ! hiera('keystone_Address', false) {
      runtime_fail { 'neutronserverkeystonedep':
        fail    => true,
        message => "neutron-server requires keystone_Address",
      }
    } else {

      if ! hiera('nova-api_Address', false) {
        runtime_fail { 'neutronservernovaapidep':
          fail    => true,
          message => "neutron-server requires nova-api_Address",
        }
      } else {
        Consul_profile::Discovery::Consul::Multidep<| title == 'neutronmultidep' |> {
          includes +> ['::neutron::server',
                       '::neutron::server::notifications',
                       '::consul_profile::discovery::consul::network_server']
        }

        profile::firewall::rule { '210 neutron-server accept tcp':
          port   => 9696,
          extras => $extras
        }
      }
    }
  }

}
