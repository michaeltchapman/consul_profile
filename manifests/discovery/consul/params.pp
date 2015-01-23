class consul_profile::discovery::consul::params {

$openstack_api_tags = [
      'haproxy::bind_interface:internal',
      'haproxy::bind_interface:external',
      'haproxy::listen:balance roundrobin',
      'haproxy::listen:option forwardfor',
      'haproxy::listen:option  httplog',
      'haproxy::mode: http',
      'haproxy::server:check inter 10s']
}
