define consul_profile::highavailability::loadbalancing::haproxy::balancermember (
  $service,
  $service_hash
) {
  $nn = delete($title, $service)
  notice($nn)
  $_back_tags = grep($service_hash[$service][$nn]['ServiceTags'], 'haproxy::server:')
  $back_tags = delete($_back_tags[0], 'haproxy::server:')
  validate_string($back_tags)
  $address   = $service_hash[$service][$nn]['Address']
  $node  = $service_hash[$service][$nn]['Node']
  $port      = $service_hash[$service][$nn]['ServicePort']
  notice("balancermember for service $service on node $node at $address on port $port with tags $back_tags")

  ::haproxy::balancermember { "${service}${node}":
    listening_service => $service,
    ports             => $port,
    ipaddresses       => $address,
    server_names      => $node,
    options           => $back_tags,
  }
}
