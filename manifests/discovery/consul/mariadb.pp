#
class consul_profile::discovery::consul::mariadb (
) {
  consul::service { 'mysql':
    port    => 3306,
    require => Service['mysqld'],
    tags    => ['haproxy::balancemember'],
    checks  => [{ 'script' => 'systemctl status mariadb && netstat -tunpl | grep 3306',
                  'interval' => '5s' }]
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
