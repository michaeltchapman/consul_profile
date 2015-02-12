class consul_profile::discovery::consul::params {
  $openstack_api_haproxy_config = {
    'interfaces'    => ['internal', 'external'],
    'listen'        => {'balance' => 'roundrobin',
                     'option'  => ['forwardfor',
                                   'httplog']},
    'mode'          => 'http',
    'server'        => ['check inter 10s'],
  }
}
