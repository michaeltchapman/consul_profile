#
class consul_profile::discovery::consul::mariadb (
) {
  consul::service { 'mysql':
    port    => 3306,
    require => Service['mysqld']
  }

  $haproxy_data = {
    'listen'     => { 'balance' => 'roundrobin',
                      'option'  => ['tcpka',
                                    'tcplog']},
    'interfaces' => ['internal'],
    'mode'       => 'tcp',
    'server'     => ['check inter 10s']
  }
  consul_profile::discovery::consul::haproxy_service { 'mysql':
    config_hash => $haproxy_data
  }
}
