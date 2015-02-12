#
define consul_profile::discovery::consul::haproxy_service (
  $config_hash,
  $datacenter = 'default',
) {
  $config_jsonstring = inline_template("<%- require 'json' -%><%= JSON.pretty_generate(Hash[@config_hash.sort]) %>")

  # Node (balancemember) config
  consul_kv { "hiera/haproxy::${datacenter}::${name}::${hostname}::config_hash":
    value => $config_jsonstring
  }

  # Service (listen) config - required since some service exporters will not be balancemembers,
  # so we need a consistent location to look for listen config.
  consul_kv { "hiera/haproxy::${datacenter}::${name}::config_hash":
    value => $config_jsonstring
  }
}
