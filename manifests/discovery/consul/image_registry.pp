#
class consul_profile::discovery::consul::image_registry (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'glance-registry':
    port    => 9191,
    require => Service['glance-registry'],
    tags    => $::consul_profile::discovery::consul::params::openstack_api_tags
  }
}
