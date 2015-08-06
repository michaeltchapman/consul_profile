class consul_profile::highavailability::loadbalancing::haproxy (
  $service_hash = undef,
  $bind_address_hash = {},
  $ts_ensure = 'installed',
  $consul_ui = true,
  $apply_wrapper = '/vagrant/provision/tspuppet.sh',
  $enable_cron = true,
  $cron_minutes = 2
) {

  # This is used for consul watches
  package { 'ts':
    ensure => $ts_ensure,
  }

  if $enable_cron {
    cron { 'tspuppet':
      command     => "ts ${apply_wrapper}",
      environment => 'PATH=/bin:/usr/bin:/usr/sbin',
      user        => 'root',
      minute      => $cron_minutes,
      require     => Package['ts']
    }
  }

  if $service_hash {

    include ::haproxy

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

    consul::watch { 'haproxy_services_watch':
      type    => 'services',
      handler => "ts ${apply_wrapper}"
    }

    if $consul_ui {
      # this needs to be special cased
      ::haproxy::listen { 'consul-ui':
        bind      => { "${bind_address_hash['internal']['address']}:8500" => []},
        mode      => 'http',
        options   => { 'balance' => 'roundrobin',
                       'option'  => ['forwardfor',
                                     'httplog']},
      }

      ::haproxy::balancermember { 'consul-ui':
        listening_service => 'consul-ui',
        ipaddresses       => ['127.0.0.1'],
        server_names      => 'localhost',
        ports             => '8500',
        options           => 'check',
      }
    }

  } else {
    runtime_fail { 'haproxyservicesdep':
      fail    => true,
      message => "HAProxy requires service catalog",
    }
  }
}
