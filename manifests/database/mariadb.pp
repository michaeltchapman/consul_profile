#
class consul_profile::database::mariadb {
  include ::profile::database::mariadb
  include ::consul_profile::discovery::consul::mariadb
}
