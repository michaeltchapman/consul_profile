#
class consul_profile::discovery::consul::mariadb (
) {
  consul::service { 'mysql':
    port    => 3306,
    require => Service['mysqld']
  }
}
