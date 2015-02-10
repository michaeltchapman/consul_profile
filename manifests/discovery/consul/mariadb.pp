#
class consul_profile::discovery::consul::mariadb (
) {
  consul::service { 'mysql':
    port    => 3306,
    tags    => [
      'haproxy::listen:balance roundrobin',
      'haproxy::listen:option tcpka',
      'haproxy::mode:tcp',
      'haproxy::server:check inter 10s',
      'haproxy::interface:internal',
    ],
    require => Service['mysqld']
  }
}
