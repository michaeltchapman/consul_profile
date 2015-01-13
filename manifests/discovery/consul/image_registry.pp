#
class consul_profile::discovery::consul::image_registry (
) {
  consul::service { 'glance-registry':
    port    => 9191,
    require => Service['glance-registry']
  }
}
