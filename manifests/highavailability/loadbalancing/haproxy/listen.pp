define consul_profile::highavailability::loadbalancing::haproxy::listen (
  $service_hash,
  $bind_address_hash = undef,
  $datacenter = 'default'
) {
  $config = $service_hash[$title]

  # haproxy::listen can be used to create a listen stanza with no members.
  # though I can't think of a use for that right now.
  if 'haproxy::listen' in $service_hash[$title]['tags'] or 'haproxy::balancemember' in $service_hash[$title]['tags'] {
    $skip = false
  } else {
    $skip = true
  }

  if !$skip {
    $json_config_hash = hiera("haproxy::${datacenter}::${title}::config_hash", false)
    if $json_config_hash {
      $config_hash = parsejson($json_config_hash)
    } else {
      warning("Unable to locate config hash for haproxy service ${title} at haproxy::${datacenter}::${title}::config_hash")
    }
  }

  if !$skip and $config_hash {
    $nodes = keys(delete($service_hash[$title], 'tags'))

    if 'listen' in keys($config_hash) {
      $listen_options = $config_hash['listen']
    } else {
      $listen_options = {}
    }

    if 'bind_internal' in keys($config_hash) {
      $bind_internal = $config_hash['bind_internal']
    } elsif 'bind' in keys($config_hash) {
      $bind_internal = $config_hash['bind']
    } else {
      $bind_internal = []
    }

    if 'bind_external' in keys($config_hash) {
      $bind_external = $config_hash['bind_external']
    } elsif 'bind' in keys($config_hash) {
      $bind_external = $config_hash['bind']
    } else {
      $bind_external = []
    }

    if 'mode' in keys($config_hash) {
      $mode = $config_hash['mode']
    } else {
      $mode = 'http'
    }

    if 'interfaces' in keys($config_hash) {
      $bind_interfaces = $config_hash['interfaces']
    } else {
      $bind_interfaces = ['internal']
    }

    # TODO make this overridable from the config hash
    $port = $service_hash[$title][$nodes[0]]['ServicePort']

    if 'internal' in $bind_interfaces {
      $internal_address = $bind_address_hash['internal']['address']
    }

    if 'external' in $bind_interfaces {
      $external_address = $bind_address_hash['external']['address']
    }

    if $internal_address and $external_address {
      $bind = { "${internal_address}:${port}" => $bind_internal,
                "${external_address}:${port}" => $bind_external }
    } elsif $external_address {
      $bind = { "${external_address}:${port}" => $bind_external }
    } elsif $internal_address {
      $bind = { "${internal_address}:${port}" => $bind_internal }
    } else {
      # Do nothing at all.
      $bind = false
    }

    if $bind {
      ::haproxy::listen { $title:
        mode             => $mode,
        collect_exported => false,
        options          => $listen_options,
        bind             => $bind,
        ipaddress        => false,
      }

      # TODO: This needs more smarts
      $firewall_title = delete($title, '-')
      ::profile::firewall::rule { "200 ${firewall_title} tcp ${port}":
        port => $port
      }

      # watch the service catalog
      ::consul::watch { "haproxy_service_${title}":
        type    => 'service',
        service => $title,
        handler => 'ts puppet apply /etc/puppet/manifests/site.pp',
      }

      # Register this service as being balanced
      consul::service { $title:
        tags    => ['haproxy::balanced'],
        port    => $port,
        require => Service['haproxy']
      }

      $titles = prefix($nodes, $title)
      consul_profile::highavailability::loadbalancing::haproxy::balancermember { $titles:
        service        => $title,
        service_hash   => $service_hash
      }
    }
  }
}

