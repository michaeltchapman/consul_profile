#
class consul_profile::messaging::rabbitmq {
  consul::service { 'rabbitmq':
    port    => 5672,
    require => Service['rabbitmq-server']
  }

  include ::profile::messaging::rabbitmq
}
