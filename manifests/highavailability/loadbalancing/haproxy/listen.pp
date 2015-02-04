define consul_profile::highavailability::loadbalancing::haproxy::listen (
  $service_hash,
  $bind_address_hash = undef
) {
  $config = $service_hash[$title]
  $backends =  keys(delete($service_hash[$title], 'tags'))
  $_backends = join( $backends, ' ' )
  $tags = $service_hash[$title]['tags']

  $_listen_options = grep($service_hash[$title]['tags'], 'haproxy::listen:' )
  $__listen_options = split(delete(join($_listen_options, '%%%'), 'haproxy::listen:'), '%%%')

  $_mode = grep($service_hash[$title]['tags'], 'haproxy::mode:' )
  $__mode = unique(split(delete(join($_mode, '%%%'), 'haproxy::mode:'), '%%%'))
  if count($__mode) > 0 {
    $mode = $__mode[0]
  } else {
    $mode = 'http'
  }

  $_skip = grep($service_hash[$title]['tags'], 'haproxy::skip:' )
  $__skip = unique(split(delete(join($_skip, '%%%'), 'haproxy::skip:'), '%%%'))
  if count($__skip) > 0 {
    $skip = $__skip[0]
  } else {
    $skip = false
  }

  $_port = grep($service_hash[$title]['tags'], 'haproxy::port:' )
  $__port = unique(split(delete(join($_port, '%%%'), 'haproxy::port:'), '%%%'))
  if count($__port) > 0 {
    $port = $__port #can be an array #TODO support this
  } else {
    $port = $service_hash[$title][$backends[0]]['ServicePort']
  }

  $_bind_options = grep($service_hash[$title]['tags'], 'haproxy::bind_option:' )
  $__bind_options = unique(split(delete(join($_bind_options, '%%%'), 'haproxy::bind_option:'), '%%%'))
  if count($__bind_options) > 0 {
    $bind_options = join($__bind_options, ' ')
  } else {
    $bind_options = ''
  }

  $_bind_interfaces = grep($service_hash[$title]['tags'], 'haproxy::bind_interface:' )
  $bind_interfaces = unique(split(delete(join($_bind_interfaces, '%%%'), 'haproxy::bind_interface:'), '%%%'))

  if 'internal' in $bind_interfaces {
    $internal_address = $bind_address_hash['internal']['address']
  }

  if 'external' in $bind_interfaces {
    $external_address = $bind_address_hash['external']['address']
  }

  $_internal_options = grep($service_hash[$title]['tags'], 'haproxy::internal_bind_options:' )
  $internal_options_array = split(delete(join($_internal_options, '%%%'), 'haproxy::internal_bind_options:'), '%%%')

  $_external_options = grep($service_hash[$title]['tags'], 'haproxy::external_bind_options:' )
  $external_options_array = split(delete(join($_external_options, '%%%'), 'haproxy::external_bind_options:'), '%%%')

  notice("Service: $title, Nodes: ${_backends}")
  notice("Service: $title, Frontend Options: ${__listen_options}")
  notice("Service: $title, Mode: ${mode}")
  notice("Service: $title, Port(s): ${port}")
  notice("Service: $title, Bind Options(s): ${bind_options}")
  notice("Service: $title, Bind Interface(s): ${__bind_interfaces}")

  if $internal_address and $external_address {
    $bind = { "${internal_address}:${port}" => $internal_options_array,
              "${external_address}:${port}" => $external_options_array }
  } elsif $external_address {
    $bind = { "${external_address}:${port}" => $external_options_array}
  } elsif $internal_address {
    $bind = { "${internal_address}:${port}" => $internal_options_array}
  } else {
    # Do nothing at all.
  }

  notice("Service: $title, Bind hash: ${bind}")

  # new bind format for listen type zzzzzzzzz
  #$bind = { '10.0.0.1:80' => ['ssl', 'crt', '/path/to/my/crt.pem'] }

  if $bind and !$skip {
    ::haproxy::listen { $title:
      mode             => $mode,
      collect_exported => false,
      options          => $_listen_options,
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

    $titles = prefix($backends, $title)
    consul_profile::highavailability::loadbalancing::haproxy::balancermember { $titles:
      service        => $title,
      service_hash   => $service_hash
    }
  }

}

