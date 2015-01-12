#
class profile::discovery::consul::services::image_registry (
) {
  consul::service { 'glance-registry':
    port    => 9191,
    require => Service['glance-registry']
  }
}
