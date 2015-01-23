#
class consul_profile::discovery::consul::identity (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'keystone':
    port    => 5000,
    require => Service['keystone'],
    tags    => $::consul_profile::discovery::consul::params::openstack_api_tags
  }
}
