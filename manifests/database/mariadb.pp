#
class consul_profile::database::mariadb {
  consul::service { 'mysql':
    port    => 3306,
    require => Service['mysqld']
  }

  include ::profile::database::mariadb
}
