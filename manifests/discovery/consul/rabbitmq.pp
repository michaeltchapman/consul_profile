#
class consul_profile::discovery::consul::rabbitmq (
) {
  consul::service { 'rabbitmq':
    port    => 5672,
    require => Service['rabbitmq-server'],
    tags    => [ 'haproxy::skip' ]
  }
}
