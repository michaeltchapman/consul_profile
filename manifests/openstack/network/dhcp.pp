class consul_profile::openstack::network::dhcp {
  include consul_profile::openstack::network

  include ::neutron::agents::dhcp
}
