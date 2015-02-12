class consul_profile::highavailability::loadbalancing::haproxy (
  $service_hash = undef,
  $bind_address_hash = {},
  $ts_ensure = 'installed'
) {

  # This is used for consul watches
  package { 'ts':
    ensure => $ts_ensure,
  }

  if $service_hash {

    include ::haproxy

    notice($service_hash)
    $services = keys($service_hash)

    consul_profile::highavailability::loadbalancing::haproxy::listen { $services:
      service_hash      => $service_hash,
      bind_address_hash => $bind_address_hash
    }

    $interfaces = keys($bind_address_hash)
    $interfaces_tags = flatten(prefix(keys($bind_address_hash), "haproxy::interface:"))

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
