class consul_profile::highavailability::loadbalancing::haproxy (
  $service_hash = {},
  $bind_address_hash = {}
) {
  if $service_hash {

    include ::haproxy
    notice($service_hash)
    $services = keys($service_hash)

    consul_profile::highavailability::loadbalancing::haproxy::listen { $services:
      service_hash      => $service_hash,
      bind_address_hash => $bind_address_hash
    }


    $interfaces = keys($bind_address_hash)
    $_interfaces_tags = prefix(keys($bind_address_hash), "haproxy::interface:")
    $interfaces_tags = flatten([$_interfaces_tags, 'haproxy::skip: true'])

    consul::service { 'haproxy':
      tags    => $interfaces_tags,
      require => Service['haproxy']
    }

  } else {
    runtime_fail { 'haproxyservicesdep':
      fail    => true,
      message => "HAProxy requires service catalog",
    }
  }
}
