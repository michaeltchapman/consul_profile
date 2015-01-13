#
class consul_profile::discovery::consul::compute_api (
) {
  consul::service { 'nova-api':
    port    => 8774,
    require => Service['nova-api'],
  }
  consul::service { 'nova-api-ec2':
    port    => 8773,
    require => Service['nova-api'],
  }
  consul::service { 'nova-api-metadata':
    port    => 8775,
    require => Service['nova-api'],
  }

}
