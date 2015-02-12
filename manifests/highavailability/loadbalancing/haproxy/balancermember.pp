define consul_profile::highavailability::loadbalancing::haproxy::balancermember (
  $service,
  $service_hash,
  $datacenter = 'default'
) {

  $nn = delete($title, $service)
  $json_config_hash = hiera("haproxy::${datacenter}::${service}::${nn}::config_hash", false)
  if $json_config_hash {
    $config_hash = parsejson($json_config_hash)
    if 'server' in $config_hash {
      $options = $config_hash['server']
    } else {
      $options = []
    }
  } else {
    $options = []
  }

  # this is also checked in 'listen', but we might have nodes exporting this service
  # that should not be added as balancermembers
  if 'haproxy::balancemember' in $service_hash[$service][$nn]['ServiceTags'] {
    $balancemember = true
  } else {
    $balancemember = false
  }

  if $balancemember {
    $address   = $service_hash[$service][$nn]['Address']
    $node  = $service_hash[$service][$nn]['Node']
    $port      = $service_hash[$service][$nn]['ServicePort']

    ::haproxy::balancermember { "${service}${node}":
      listening_service => $service,
      ports             => $port,
      ipaddresses       => $address,
      server_names      => $node,
      options           => $options,
    }

    ::consul::watch { "haproxy_kv_${title}":
      type    => 'key',
      key     => "hiera/haproxy::${datacenter}::${service}::${nn}::config_hash",
      handler => 'ts puppet apply /etc/puppet/manifests/site.pp',
    }
  }
}
