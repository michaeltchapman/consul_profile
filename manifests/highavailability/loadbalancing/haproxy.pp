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

    #create_resources('haproxy::listen', $haproxy_listens)
    #create_resources('haproxy::balancermember', $haproxy_balancermembers)
  }

  $interfaces = keys($bind_address_hash)
  $interfaces_tags = prefix(keys($bind_address_hash), "haproxy::interface:")

  consul::service { 'haproxy':
    tags => $interfaces_tags,
    require => Service['haproxy']
  }
}
