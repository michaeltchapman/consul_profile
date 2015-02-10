#
define consul_profile::discovery::consul::haproxy_service (
  $config_hash,
  $datacenter = undef,
) {
  $config_jsonstring = inline_template("<%- require 'json' -%><%= JSON.pretty_generate(Hash[@config_hash.sort]) %>")

  if $datacenter {
    $ds = "${datacenter}::"
  } else {
    $ds = 'default::'
  }

  consul_kv { "hiera/haproxy::${ds}${name}::config_hash":
    value => $config_jsonstring
  }
}
