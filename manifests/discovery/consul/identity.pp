#
class consul_profile::discovery::consul::identity (
) {
  consul::service { 'keystone':
    port    => 5000,
    require => Service['keystone']
  }
}
