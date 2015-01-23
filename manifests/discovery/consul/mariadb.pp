#
class consul_profile::discovery::consul::mariadb (
) {
  consul::service { 'mysql':
    port    => 3306,
    tags    => [
      'haproxy::frontend:balance roundrobin',
      'haproxy::frontend:option tcpka',
      'haproxy::mode:tcp',
      'haproxy::server:check inter 10s',
      'haproxy::interface:external',
    ],
    require => Service['mysqld']
  }
}
