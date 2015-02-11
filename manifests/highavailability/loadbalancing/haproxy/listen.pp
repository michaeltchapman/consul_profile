define consul_profile::highavailability::loadbalancing::haproxy::listen (
  $service_hash,
  $bind_address_hash = undef,
  $datacenter = 'default'
) {
  $config = $service_hash[$title]

  # Skip is a tag so we have to parse it out. Other config should be in the config hash
  $_skip = grep($service_hash[$title]['tags'], 'haproxy::skip:' )
  $__skip = unique(split(delete(join($_skip, '%%%'), 'haproxy::skip:'), '%%%'))
  if count($__skip) > 0 {
    $skip = $__skip[0]
  } else {
    $skip = false
  }

  $nodes =  keys(delete($service_hash[$title], 'tags'))
  $json_config_hash = hiera("haproxy::${datacenter}::${title}::${nodes[0]}::config_hash", false)
  if $json_config_hash {
    $config_hash = parsejson($json_config_hash)
  } else {
    notice("Unable to locate config hash for haproxy service ${title}")
  }

  notice($config_hash)

  if !$skip and $config_hash {

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

    notice("Service: $title, Nodes: ${nodes}")
    notice("Service: $title, Frontend Options: ${listen_options}")
    notice("Service: $title, Mode: ${mode}")
    notice("Service: $title, Port(s): ${port}")
    notice("Service: $title, Bind External: ${bind_external}")
    notice("Service: $title, Bind Internal: ${bind_internal}")
    notice("Service: $title, Bind Interface(s): ${bind_interfaces}")

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

    notice("Service: $title, Bind hash: ${bind}")

    # new bind format for listen type zzzzzzzzz
    #$bind = { '10.0.0.1:80' => ['ssl', 'crt', '/path/to/my/crt.pem'] }

    if $bind {
      ::haproxy::listen { $title:
        mode             => $mode,
        collect_exported => false,
        options          => $listen_options,
        bind             => $bind,
        ipaddress        => false,
      }

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

      # TODO: watch the k/v store
      #::consul::watch { "haproxy_kv_${title}":
      #  type    => 'service',
      #  service => $title,
      #  handler => 'puppet apply /etc/puppet/manifests/site.pp',
      #}

      $titles = prefix($nodes, $title)
      consul_profile::highavailability::loadbalancing::haproxy::balancermember { $titles:
        service        => $title,
        service_hash   => $service_hash
      }
    }
  }
}

