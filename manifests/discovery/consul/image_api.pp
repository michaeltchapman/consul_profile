#
class consul_profile::discovery::consul::image_api (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'glance-api':
    port    => 9292,
    require => Service['glance-api'],
    tags    => $::consul_profile::discovery::consul::params::openstack_api_tags
  }
}
