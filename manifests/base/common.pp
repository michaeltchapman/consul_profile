class consul_profile::base::common(
  $datacenter      = 'dev',
  $authorized_host = undef
) {

  $auth_key_value = hiera("ssh::${datacenter}::${authorized_host}", false)

  file { '/root/.ssh':
    ensure => 'directory'
  } ->

  file { '/root/.ssh/id_rsa':
    ensure => 'link',
    target => '/etc/ssh/ssh_host_rsa_key'
  }

  # if the auth key hasn't been set, this is probably our first rodeo,
  # so regenerate our host key for great security.
  if !$auth_key_value {
    exec { 'Regenerate RSA host keys':
      command => "echo -e 'y\\n' | ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key",
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      before  => Consul_kv["hiera/ssh::${datacenter}::${hostname}"]
    }
  }

  consul_kv { "hiera/ssh::${datacenter}::${hostname}":
    value => $::sshrsakey
  }

  if $authorized_host and $auth_key_value {
    ssh_authorized_key { 'consul_authorized_host':
      key  => $auth_key_value,
      type => 'ssh-rsa',
      user => 'root'
    }
  }
}
