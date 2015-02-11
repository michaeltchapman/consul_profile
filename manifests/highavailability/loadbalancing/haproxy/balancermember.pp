define consul_profile::highavailability::loadbalancing::haproxy::balancermember (
  $service,
  $service_hash,
  $datacenter = 'default'
) {

  $nn = delete($title, $service)
  notice($nn)
  notice("haproxy::${datacenter}::${service}::${nn}::config_hash")
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

  notice($config_hash)

  $address   = $service_hash[$service][$nn]['Address']

  $node  = $service_hash[$service][$nn]['Node']

  $port      = $service_hash[$service][$nn]['ServicePort']

  notice("balancermember for service $service on node $node at $address on port $port with tags $options")

  ::haproxy::balancermember { "${service}${node}":
    listening_service => $service,
    ports             => $port,
    ipaddresses       => $address,
    server_names      => $node,
    options           => $options,
  }
}
