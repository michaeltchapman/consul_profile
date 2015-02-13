#
class consul_profile::discovery::consul::image_api (
) {
  include consul_profile::discovery::consul::params

  consul::service { 'glance-api':
    port         => 9292,
    require      => Service['glance-api'],
    tags         => ['haproxy::balancemember'],
    check_script => 'systemctl status openstack-glance-api && netstat -tunpl | grep 9292',
    check_interval => '5s'
  }

  consul_profile::discovery::consul::haproxy_service { 'glance-api':
    config_hash => $::consul_profile::discovery::consul::params::openstack_api_haproxy_config
  }
}
