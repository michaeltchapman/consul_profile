class consul_profile::openstack::compute::api(
  $manage_firewall = true,
  $firewall_extras = {}
) {
  include ::consul_profile::openstack::compute

  if ! hiera('service_hash__haproxy::balanced__keystone_Address', false) {
    runtime_fail { 'novaapikeystonedep':
      fail    => true,
      message => "Nova api requires keystone_Address",
    }
  } else {
    Consul_profile::Discovery::Consul::Multidep <| title == 'novamultidep' |> {
      includes +> ['::nova::api', '::consul_profile::discovery::consul::compute_api']
    }

    if $manage_firewall {
      profile::firewall::rule { '231 compute api accept tcp':
        port   => 8774,
        extras => $firewall_extras
      }

      profile::firewall::rule { '232 compute api-ec2 accept tcp':
        port   => 8773,
        extras => $firewall_extras
      }

      profile::firewall::rule { '233 compute api-metadata accept tcp':
        port   => 8775,
        extras => $firewall_extras
      }
    }
  }
}
